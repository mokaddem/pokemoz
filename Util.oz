functor

export

CustomNewCell
CellSet
CellGet

define

	fun {CustomNewCell Init}
		P S
		proc {Loop S State}
			case S of Msg|S2 then
				{Loop S2 {HandleMsg Msg State}}
			end
		end
		fun {HandleMsg Msg State}
			case Msg 
				of access(Val) then Val=State State
				[]assign(Val) then Val
			end
		end
	in
		P = {NewPort S}
		thread {Loop S Init} end
		P
	end
	
	fun {CellGet Cell}
		Val in
		{Send Cell access(Val)}
		Val
	end

	proc {CellSet Cell Val}
		{Send Cell assign(Val)}
	end

end

