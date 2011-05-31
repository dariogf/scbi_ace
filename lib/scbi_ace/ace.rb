# Description: This class provided the methods to parse and write an ACE file and to add contigs to the Ace
# ---- Author: Noe Fernandez Pozo
# ------ Date: 31-May-2011

require 'contig'

class Ace
	
	attr_accessor :name,:contigs,:reads_count
	
	def initialize(ace_file)
		@ace_file = ace_file
		@name = ace_file.sub(/.+\//,'')
		@contigs = []
		@reads_count = 0
		
		parse
		
	end
	
	# def each_contig
	# 	contig=leer_next_contig
	# 	yield contig
	# end

	def write_ace
		
		ace_to_print = []
		
		ace_to_print.push "AS #{@contigs.count} #{@reads_count}"

		@contigs.each do |contig|
			#---------------------------------------------- CO
			ace_to_print.push "CO #{contig.name} #{contig.length} #{contig.reads_num} #{contig.bs_num} #{contig.orientation}"
			ace_to_print.push contig.fasta.scan(/.{1,60}/m)
			
			#---------------------------------------------- BQ
			ace_to_print.push "\nBQ"
			seq_qual = contig.qual.split(" ")
			count = 0
			qv_line = ''
			seq_qual.each do |qv|
				count+=1
				qv_line << "#{qv} "
				if (count % 60 == 0)
					ace_to_print.push qv_line
					qv_line = ''
				end
			end

			ace_to_print.push ""
			#---------------------------------------------- AF
			af_array = []
			contig.reads.each_value do |read|
				ace_to_print.push "AF #{read.name} #{read.orientation} #{read.start_in_consensus}"
				af_array.push read.name
			end

			#---------------------------------------------- BS
			bs_array = []
			contig.reads.each_value do |read|
				bs_array = bs_array + read.bs
			end

			bs_array.sort!{|a,b| a['padded_start_consensus'].to_i<=>b['padded_start_consensus'].to_i}
			bs_array.each do |bs_hash|
				ace_to_print.push "BS #{bs_hash['padded_start_consensus']} #{bs_hash['padded_end_consensus']} #{bs_hash['read_name']}"
			end
			
			#----------------------------------------------- RD
			af_array.each do |name|
				contig.reads[name]
				ace_to_print.push "\nRD #{name} #{contig.reads[name].padded_bases_num} #{contig.reads[name].item_num} #{contig.reads[name].tag_num}"
				ace_to_print.push contig.reads[name].fasta.scan(/.{1,60}/m)
				ace_to_print.push "\nQA #{contig.reads[name].qual_clip_start} #{contig.reads[name].qual_clip_end} #{contig.reads[name].align_clip_start} #{contig.reads[name].align_clip_end}"
				ace_to_print.push "DS"
			end
		end
		
		return ace_to_print.join("\n")
	end
	
private
	
	def add_contig(contig_name,contig_length,reads_num,bs_num,orientation)
		contig= Contig.new(contig_name,contig_length,reads_num,bs_num,orientation)
	
		@contigs.push contig
		return contig
	
	end

	def parse
		
		contig = nil
		read = nil
		save_fasta = false
		save_read_fasta = false
		save_qual = false
		contig_fasta = ''
		read_fasta = ''
		contig_qual = ''
		bs = {}
		
		my_ace = File.open(@ace_file)
		@reads_count = my_ace.readline.sub(/^AS\s+\d+\s+/,'')
		
		my_ace.each do |line|
			line.chomp!
			#---------------------------------------------- contig fasta
			if (save_fasta)
				if !(line =~ /^./)
					contig.add_fasta(contig_fasta)
					save_fasta = false
					contig_fasta = ''
				end
				contig_fasta << line
			end
			#---------------------------------------------- contig qual
			if (save_qual)
				if !(line =~ /^./)
					contig.add_qual(contig_qual)
					save_qual = false
					contig_qual = ''
				end
				contig_qual << line
			end
			#---------------------------------------------- read fasta
			if (save_read_fasta)
				if !(line =~ /^./)
					read.add_fasta(read_fasta)
					save_read_fasta = false
					read_fasta = ''
				end
				read_fasta << line
			end
			
			#---------------------------------------------- CO
			if (line =~ /^CO\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)/)
				contig_name = $1
				contig_length = $2
				reads_num = $3
				bs_num = $4
				orientation = $5
				save_fasta = true
				contig = add_contig(contig_name,contig_length,reads_num,bs_num,orientation)
			end
			
			#---------------------------------------------- BQ
			if (line =~ /^BQ/)
				save_qual = true
			end
			
			#---------------------------------------------- AF
			if (line =~ /^AF\s+([^\s]+)\s+([A-Z])\s+([^\s]+)/)
				read_name = $1
				orientation = $2
				start_consensus = $3
				
				contig.add_read(read_name,orientation,start_consensus)
			end
			
			#---------------------------------------------- BS
			if (line =~ /^BS\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)/)
				padded_start_consensus = $1
				padded_end_consensus = $2
				read_name = $3
				
				bs['padded_start_consensus'] = padded_start_consensus
				bs['padded_end_consensus'] = padded_end_consensus
				bs['read_name'] = read_name
				
				read = contig.reads[read_name]
				read.add_bs(bs)
				bs = {}
			end
			
			#---------------------------------------------- RD
			if (line =~ /^RD\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)/)
				read_name = $1
				padded_bases_num = $2
				item_num = $3
				tag_num = $4
				save_read_fasta = true
				
				read = contig.reads[read_name]
				read.add_data(padded_bases_num,item_num,tag_num)
			end
			
			#---------------------------------------------- QA
			if (line =~ /^QA\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)/)
				qual_clip_start = $1
				qual_clip_end = $2
				align_clip_start = $3
				align_clip_end = $4
				
				read.add_qual_clipping(qual_clip_start, qual_clip_end, align_clip_start, align_clip_end)
			end
		end
	end
	
end