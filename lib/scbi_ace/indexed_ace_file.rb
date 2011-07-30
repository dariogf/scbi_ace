
class ContigNotFountException < RuntimeError 
end


class IndexedAceFile

				  READ_REG_EXP=  /^([^\s]+)\s+([^\s]+)\s+([^\s]+)/

	attr_reader :ace_file_name

	def initialize(ace_file_name)
			#@ace_file = File.open(ace_file_name)
			@ace_file_name = ace_file_name
			
			index_file_name=ace_file_name+'.scbi_index'

			if !File.exists?(index_file_name)
			  create_index_file(index_file_name)
			end
			
			@index_file = File.open(index_file_name)
	
	end
	
	def self.open(ace_file_name)
			return new(ace_file_name)
	end
	
	def each
	
	end
	
	def read_contig(contig_name)
			res = nil	
			@index_file.pos=0
					
			@index_file.grep(/^#{contig_name}\s/) do |line|
    
				 e=line.chomp

				# parse params
				if e=~ READ_REG_EXP
				
					#get line
					
					length=$3.to_i #4152
					offset=$2.to_i #3289232
					#puts line
					res=File.read(@ace_file_name,length,offset)
				
				end
				
			end

			return res
	end
	
	def create_index_file(index_file_name)
	
			puts "creating index file #{index_file_name}"
			 
			 start_pos=0
			 end_pos = 0
			 contig=nil
			 
			 @index_file = File.open(index_file_name,'w+')
			
			 
			#(ace_file=File.open(@ace_file_name)).each_line	do |line|
			(ace_file=File.open(@ace_file_name)).grep(/^\s*CO\s/) do |line|
			  puts ace_file.pos, line.length
				end_pos = ace_file.pos - line.length
				  
        #puts line
				if line=~/^\s*CO\s+([^\s]+\s)/
				  
					if contig							
							#from = last_pos if from == 0 
							
							@index_file.puts "#{contig}\t#{start_pos}\t#{end_pos-start_pos}"
							
              # puts "#{contig}\t#{start_pos}\t#{offset}"
							
							
					end
					
				  start_pos = end_pos

					contig = $1

				end
				
				#last_pos = ace_file.pos
				#offset=last_pos - from
			end
			
			if contig
							end_pos = ace_file.pos
							@index_file.puts "#{contig}\t#{start_pos}\t#{end_pos-start_pos}"
							puts "#{contig}\t#{start_pos}\t#{end_pos-start_pos}"
			end
			
			@index_file.close
	end

	
	def close
		#@ace_file.close	
		@index_file.close
	end
	
	


end
