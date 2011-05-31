# Description: This class provided the methods to add Reads data
# ---- Author: Noe Fernandez Pozo
# ------ Date: 31-May-2011

class Read
	
	attr_accessor :name, :orientation, :start_in_consensus, :bs, :fasta
	attr_accessor :padded_bases_num, :item_num, :tag_num
	attr_accessor :qual_clip_start, :qual_clip_end, :align_clip_start, :align_clip_end
	
	def initialize(name,orientation,start_in_consensus)
		@name = name
		@orientation = orientation
		@start_in_consensus = start_in_consensus
		@bs = []
	end
	
	def add_fasta(fasta)
		@fasta = fasta
	end
	
	def add_data(padded_bases_num,item_num,tag_num)
		@padded_bases_num = padded_bases_num
		@item_num = item_num
		@tag_num = tag_num
	end
	
	def add_qual_clipping(qual_clip_start, qual_clip_end, align_clip_start, align_clip_end)
		@qual_clip_start = qual_clip_start
		@qual_clip_end = qual_clip_end
		@align_clip_start = align_clip_start
		@align_clip_end = align_clip_end
	end
	
	def add_bs(bs)
		@bs.push bs
	end
	
end