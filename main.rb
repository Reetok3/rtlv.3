require 'byebug'
class Rtl
	def initialize(code)
		# コード
		@code = code
		# コードのスペース区切り
		@chomp = @code.split(" ")
		@tokenVar = []
		@token = []
		@typeVar = []
		@var = {}
		srand(Time.now.to_i)
	end
	def lexer
		i=0
		while true do
			case @chomp[i]
			when /\w==\w/ || /\w!=\w/ || /\w<\w/ || /\w>\w/ || "true" || "false"
				# COND 条件式
				push("COND",@chomp[i],"tof")
			when /"([\w\s,!?\.=]*)"/
				# STRING 文字列
				push("STRING",$1,"char")
			when /(\w(\+|-))+\w/
				# EXP 計算式（変数）
				push("EXP",@chomp[i],"int")
			when /\d+/
				# INTEGER 数値
				push("INTEGER",@chomp[i],"int")
			when "print"
				# print文"
				push("INTEGER",@chomp[i],"")
			when "integer"
				push("CNV_I","integer","int")
			when "string"
				push("CNV_S","string","char")
			when "random"
				# 乱数生成
				push("RANDOM","random","int")
			when "do" || "then"
				# while||if開始
				push("DO","do","")
			when "if"
				# if文
				push("IF","if","")
			when "endif"
				# if文Close
				push("IF_END","endif","")
			when "while"
				push("WHILE","while","")
			when "endwhile"
				# while文Close
				push("WHILE_END","endwhile")
			when "loop"
				push("LOOP","loop","")
			when "endloop"
				push("LOOP_END","endloop")
			when "exit"
				push("EXIT","exit","")
			when "="
				# 変数代入イコール
				push("EQUAL","=","")
			when nil
				# 終了
				break
			when "//"
				i+=1
			when "/*"
				while @chomp[i] == "*/"
					i+=1
				end
				i+=1
			else
				if @chomp[i] =~ /^[a-z]\w*/ && @chomp[i] =~ /[a-zA-Z0-9]\z/
					push("VAR","@chomp[i]","var")
				else
					error("字句エラー #{@chomp[i]}というメソッドはありません。")
				end
			end
			i+=1
		end
		return @token.size
	end

	

	def run(s,f)
		i=s
		while true do
			if ARGV[1] == "debug"
				puts "#{i}回目："
				p @token[i]
				sleep 0.25
			end
			case @token[i]
			when "PRINT"
				i+=1
				case @token[i]

				end
			when "VAR"
				i+=1
				if @token[i] == "EQUAL"
					i+=1
					case @token[i]
					end
				end
			end
#			case @token[i]
#			when "PRINT"
#				i+=1
#				case @token[i]
#				when "STRING"
#					# PRINT STRING
#					puts @tokenVar[i]
#				when "RANDOM"
#					i+=1
#					if @token[i] == "INTEGER" || @token[i] == "VAR"
#						# PRINT RANDOM INTEGER || PRINT RANDOM VAR
#						p @tokenVar[i]
#						p getVar(@tokenVar[i])
#						puts rand(getVar(@tokenVar[i]).to_i)
#					else
#						error("文法エラー #{@token[i]}以降の組み合わせは見つかりませんでした。1")
#					end
#				when "EXP"
#					# PRINT EXP
#					puts getValue(@tokenVar[i])
#				when "COND"
#					# PRINT COND
#					puts evalCond(@tokenVar[i].split(/(==|!=|<|>)/)[0],
#						      @tokenVar[i].split(/(==|!=|<|>)/)[1],
#						      @tokenVar[i].split(/(==|!=|<|>)/)[2])
#				when "VAR"
#					# PRINT VAR
#					puts getVar(@tokenVar[i])
#				when "INTEGER"
#					# PRINT INTEGER
#					puts @tokenVar[i].to_i
#				when "CNV_I"
#					i+=1
#					if @token[i] == "VAR" || @token[i] == "STRING" || @token[i] == "CNV_S"
#						puts getVar(@tokenVar[i].to_i)
#					end
#				when "CNV_S"
#					i+=1
#					if @token[i] == "VAR" || @token[i] == "INTEGER" || @token[i] == "CNV_I"
#						puts getVar(@tokeVar[i].to_a)
#					end
#				else
#					error("文法エラー #{@token[i]}以降の組み合わせは見つかりませんでした。3")
#				end
#			when "VAR"
#				i+=1
#				if @token[i] == "EQUAL"
#					i+=1
#					case @token[i]
#					when "STRING"
#						# VAR EQUAL STRING
#						@var[@tokenVar[i-2]] = @tokenVar[i]
#					when "VAR"
#						# VAR EQUAL VAR
#						@var[@tokenVar[i-2]] = getVar(@tokenVar[i])
#					when "EXP"
#						# VAR EQUAL EXP
#						@var[@tokenVar[i-2]] = getValue(@tokenVar[i+2])
#					when "COND"
#						# VAR EQUAL COND
#						@var[@tokenVar[i-2]] = evalCond(@tokenVar[i].split(/(==|!=|<|>)/)[0],
#										@tokenVar[i].split(/(==|!=|<|>)/)[1],
#										@tokenVar[i].split(/(==|!=|<|>)/)[2])
#					when "INTEGER"
#						# VAR EQUAL INTEGER
#						@var[@tokenVar[i-2]] = @tokenVar[i].to_i
#					when "CNV_I"
#						i+=1
#						if @token[i] == "VAR" || @token[i] == "STRING" || @token[i] == "INPUT" || @token[i] == "CHOMP"
#							puts getVar(@var[@tokenVar[i]].to_i)
#						end
#					when "CNV_S"
#						i+=1
#						if @token[i] == "VAR" || @token[i] == "INTEGER"
#							puts getVar(@var[@tokeVar[i]].to_a)
#
#						end
#					when "RANDOM"
#						i+=1
#						if @token[i] == "INTEGER" || @token[i] == "VAR"
#							# VAR EQUAL RANDOM INEGER || VAR EQUAL RANDOM VAR
#							@var[@tokenVar[i-3]] = rand(getVar(@tokenVar[i]).to_i)
#						else
#							error("文法エラー #{@token[i]}以降の組み合わせは見つかりませんでした。5")
#						end
#					else
#						error("文法エラー #{@token[i]}以降の組み合わせは見つかりませんでした。6")
#					end
#				else
#					error("文法エラー #{@token[i]}以降の組み合わせは見つかりませんでした。7")
#
#				end
#			when "WHILE"
#				i+=1
#				if @token[i] == "COND" && @tokenVar[i+1] = "DO"
#					start=i+2
#					finish=0
#					testi=i+2
#					cntr=1
#					cntr2=i+2
#					while cntr != 0
#						if @token[cntr2]=="DO"
#							cntr+=1
#						end
#						if @token[cntr2] == "WHILE_END" || @token[cntr2] == "IF_END" || @token[cntr2] == "LOOP_END"
#							cntr-=1
#						end
#						cntr2+=1
#					end
#					finish=cntr2-2
#					# if @chomp[testi] =~ /\w+/ && @chomp[testi+1] == "=" && ( @chomp[i] =~ /\w+-\d+/ || @cjomp[i] =~ /\w+\+\d+/ )
#					# else
#					while evalCond(@tokenVar[i].split(/(==|!=|<|>)/)[0],
#							@tokenVar[i].split(/(==|!=|<|>)/)[1],
#							@tokenVar[i].split(/(==|!=|<|>)/)[2])
#						if ARGV[1] == "debug"
#							print "whileターン"
#							run(start,finish)
#						end
#					end
#					# end
#
#				end
#			when "IF"
#				i+=1
#				if @token[i] == "COND" && @token[i+1] == "DO"
#					start=i+2
#					finish=0
#					cntr=1
#					cntr2=i+1
#					while cntr != 0
#						if @token[cntr2]=="DO"
#							cntr+=1
#						end
#						if @token[cntr2] == "WHILE_END" || @token[cntr2] == "IF_END" || @token[cntr2] == "LOOP_END"
#							cntr-=1
#						end
#						cntr2+=1
#					end
#					finish=cntr2-1+i
#					if evalCond(@tokenVar[i].split(/(==|!=|<|>)/)[0],
#							@tokenVar[i].split(/(==|!=|<|>)/)[1],
#							@tokenVar[i].split(/(==|!=|<|>)/)[2])
#						if ARGV[1] == "debug"
#							puts "ifターン"
#						end
#						run(start,finish)
#					end
#					i = finish
#				end
#			when "LOOP"
#				i+=1
#				if @token[i] == "DO"
#					start=i+1
#					finish=0
#					cntr=1
#					cntr2=i+1
#					while cntr != 0
#						if @token[cntr2]=="DO"
#							cntr+=1
#						end
#						if @token[cntr2] == "WHILE_END" || @token[cntr2] == "IF_END"
#							cntr-=1
#						end
#						cntr2+=1
#					end
#					finish=cntr2-1+i
#					while true
#						run(start,finish)
#					end
#				end
#			when "EXIT"
#				exit
#			when nil
#				break
#			else
#				if i == f+1
#					break
#				else
#					error("文法エラー #{@token[i]}以降の組み合わせは見つかりませんでした。6")
#				end
#			end
			if ARGV[1] == "debug"
				puts "\n変数："
				p @var
				puts "------------------------------------------------------------------------------------------------------"
			end
			i+=1
		end
	end
	

	def push(token,tokenVar,typeVar)
		@token.push(token)
		@tokenVar.push(tokeVar)
		@typeVar.push(typeVar)
	end

	def error(c)
		puts "エラー:#{c}"
	end

	def evalCond(l,ope,r)
		if ope == "=="
			return (getVar(l) == getVar(r))
		elsif ope == "!="
			return (getVar(l) != getVar(r))
		elsif ope == "<"
			return (getVar(l) < getVar(r))
		elsif ope == ">"
			return (getVar(l) > getVar(r))
		end
	end

	# c = 5 + 5 + 5 - 6 + 4 - 7
	def getValue(exp)
		# byebug
		if exp =~ /(\+|-)/
			exp = exp.split(/(\+|-)/)
		else
			exp = [exp]
		end
		if exp[0] == ""
			exp.delete_at(0)
		end
		i=0
		# 始め  | 数    | 演算子 | 変数
		# start | value | opr    | var
		type="start"
		acc=0
		# byebug
		while i != exp.size
			if exp[i] == "+" && type != "opr"
				type = "opr"
			elsif exp[i] == "-" && type != "opr"
				type = "opr"
			elsif exp[i] =~ /\d+/ && type != "value" && type != "var"
				type = "value"
			elsif exp[i] =~ /\w+/ && type != "var" && type != "value"
				type = "var"
				exp[i] = getVar(exp[i])
			else
			end
			i+=1
		end

		#byebug
		if exp[0] != "+" && exp[0] != "-"
			exp.unshift("+")
		end
		i=0
		while i != exp.size
			if exp[i] == "+"
				i+=1
				acc += exp[i].to_i
			elsif exp[i] == "-"
				i+=1
				acc -= exp[i].to_i
			end
			i+=1
		end
		return acc
	end

	# token = a || b (へんすうめい)
	def getVar(tokenVar)
			case tokenVar
			when /\w==\w/ || /\w!=\w/ || /\w<\w/ || /\w>\w/ || "true" || "false"
				# COND 条件式
				if evalCond(tokenVar.split(/(==|!=|<|>)/)[0],
					    tokenVar.split(/(==|!=|<|>)/)[1],
					    tokenVar.split(/(==|!=|<|>)/)[2])
					return true
				else
					return false
				end

			when /"([\w\s,!?\.=]*)"/
				# STRING 文字列
				return tokenVar
			when /(\w(\+|-))+\w/
				# EXP 計算式（変数）
				return getValue(tokenVar)
			when /\d+/
				# INTEGER 数値
				return tokenVar.to_i
			when /integer_/
				# CNV_I 数値変換
				return getVar(tokenVar).to_i
			when "string"
				# CNV_S 文字列変換
				return getVar(tokenVar).to_s
			when "random"
				# RANDOM 乱数生成
				return rand()
			else
				if @chomp[i] =~ /^[a-z]\w*/ && @chomp[i] =~ /[a-zA-Z0-9]\z/
				end
			end

	end
end

rtl = Rtl.new(ARGF.read)
rtl.run(0,rtl.lexer-1)
# a=1
# b=1
# tof = (a == b)
# puts tof # => true

# print "Hello"
# print  "Hello"
# スペース必須
#
# 計算式では，スペース禁止
#
# 真偽判定はスペース禁止
#
# 変数は，1文字目は，小文字．2文字目は，アンダースコア・小文字・大文字・数字．最後の文字は，小文字・大文字・数字．
