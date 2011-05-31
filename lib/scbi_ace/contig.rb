# Description: This class provided the methods to access to the Contig data and to add reads to the Contig
# ---- Author: Noe Fernandez Pozo
# ------ Date: 31-May-2011

require 'read'

class Contig
	
	attr_accessor :name,:length,:reads_num,:bs_num,:orientation,:reads,:reads_names,:fasta,:qual
	attr_accessor :reads,:reads_names
	attr_accessor :fasta,:qual
	
	def initialize(name,length,reads_num,bs_num,orientation)
		
		@name = name
		@length = length
		@reads_num = reads_num
		@bs_num = bs_num
		@orientation = orientation
		
		@reads = {}
		@reads_names = []
		
		@fasta = ''
		@qual = ''
	end
	
	def add_read(read_name,orientation,start_consensus)
		read= Read.new(read_name,orientation,start_consensus)
		@reads_names << read_name
		@reads[read_name] = read
		return read
	end
	
	def add_fasta(fasta)
		@fasta = fasta
	end
	
	def add_qual(qual)
		@qual = qual
	end
	
	def get_read(read_name)
		return @reads[read_name]
	end

	def get_read_names
		return @reads_names
	end
	
end