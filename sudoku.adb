 ----------------------------------------------------------
 -- Alex Lapena
 -- CIS*3190
 -- Sudoku Solver
 ----------------------------------------------------------

with ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;

procedure Sudoku is
	-- Set Array Types
	type arr is array(1..9,1..9) of integer;
	type solutions is array(integer range <>)of integer;
	
	-- Declare Variable Types	
	infp : File_Type;  
	fileName : string(1..50);
	fromFile : string(1..9);
	last: natural;
	num : arr;
	j : integer;
	
	--
	--Function to check if board is full
	--
	function isTrue(board : arr) return boolean is
		--Variable Declaration
		numCheck : integer;
		
		begin
			for x in 1..9 loop
				for y in 1..9 loop
					if board(x,y) /= 0 then
						numCheck := board(x,y);
						
						for k in 1..9 loop
							if numCheck = board(x,k) and k /= y then
								put_line("Unsolvable Puzzle");
								return false;
							end if;
							if numCheck = board(k,y) and k /= x then
								put(x);
								put(y);
								put_line("Unsolvable Puzzle");
								return false;
							end if;
							
						end loop;
					end if;
				end loop;
			end loop;
		
			return true;
		
		end isTrue;
	
	
	
	--
	--Function to check if board is full
	--
	function isFull(board : arr) return boolean is
	
		begin
			for x in 1..9 loop
				for y in 1..9 loop
					if board(x,y) = 0 then
						return false;
					end if;
				end loop;
			end loop;
			
			return true;
			
		end isFull;
	
	--
	--Function to check possibilities
	--
	function entries(board : arr; i , j : integer) return solutions is
		
		--Declare function Variables
		pA : solutions(1..9);
		
		begin
			
			for x in 1..9 loop
				pA(x) := 0;
			end loop;
			
			--Checks horizontal 
			for y in 1..9 loop
				if board(i, y) /= 0 then
					pA(board(i,y)) := 1;
				end if;
			end loop;
		
			--Checks vertical
			for x in 1..9 loop
				if board(x,j) /= 0 then
					pA(board(x,j)) := 1;
				end if;
			end loop;
			
			-- Checking the 3x3 square grid
			-- Box 1
			if i < 4 and j < 4 then
				for x in 1..3 loop
					for y in 1..3 loop
						if board(x,y) /= 0 then
							pA(board(x,y)) := 1;
						end if;
					end loop;
				end loop;
			-- Box 2
			elsif i < 4 and j < 7 then
				for x in 1..3 loop
					for y in 4..6 loop
						if board(x,y) /= 0 then
							pA(board(x,y)) := 1;
						end if;
					end loop;
				end loop;
			-- Box 3
			elsif i < 4 and j < 10 then
				for x in 1..3 loop
					for y in 7..9 loop
						if board(x,y) /= 0 then
							pA(board(x,y)) := 1;
						end if;
					end loop;
				end loop;
			-- Box 4
			elsif i < 7 and j < 4 then
				for x in 4..6 loop
					for y in 1..3 loop
						if board(x,y) /= 0 then
							pA(board(x,y)) := 1;
						end if;
					end loop;
				end loop;
			-- Box 5
			elsif i < 7 and j < 7 then
				for x in 4..6 loop
					for y in 4..6 loop
						if board(x,y) /= 0 then
							pA(board(x,y)) := 1;
						end if;
					end loop;
				end loop;
			-- Box 6
			elsif i < 7 and j < 10 then
				for x in 4..6 loop
					for y in 7..9 loop
						if board(x,y) /= 0 then
							pA(board(x,y)) := 1;
						end if;
					end loop;
				end loop;
			-- Box 7
			elsif i < 10 and j < 4 then
				for x in 7..9 loop
					for y in 1..3 loop
						if board(x,y) /= 0 then
							pA(board(x,y)) := 1;
						end if;
					end loop;
				end loop;
			-- Box 8
			elsif i < 10 and j < 7 then
				for x in 7..9 loop
					for y in 4..6 loop
						if board(x,y) /= 0 then
							pA(board(x,y)) := 1;
						end if;
					end loop;
				end loop;
			-- Box 9
			elsif i < 10 and j < 10 then
				for x in 7..9 loop
					for y in 7..9 loop
						if board(x,y) /= 0 then
							pA(board(x,y)) := 1;
						end if;
					end loop;
				end loop;
			end if;
			
			--Swaps possibilities with actual numbers into the array
			for x in 1..9 loop
				if pA(x) = 0 then
					pA(x) := x;
				else
					pA(x) := 0;
				end if;
			end loop;
			
			--returns the array of the possible solutions
			return pA;
			
		end entries;
		
	--
	--Function to solve the sudoku
	--		
	procedure solve(bArr : arr) is
		
		--Declare function variables
		pA : solutions(1..9);
		outFile : string(1..50);
		i, j : integer;
		board : arr;
		outfp : File_Type;
		last2 : natural;
		
		begin
			i := 0;
			j := 0;
			
			--Initializes the array 
			for x in 1..9 loop
				for y in 1..9 loop
					board(x,y) := bArr(x,y);
				end loop;
			end loop;
	
			--Continues to work until all 0's are filled
			if isFull(board) then
				put("Solved Sudoku: ");
				new_line;
				put("+------+------+------+");
				new_line;
				for i in 1..9 loop
					if i = 4 then
						put("+------+------+------+");
						new_line;
					elsif i = 7 then
						put("+------+------+------+");
						new_line;
					end if;
					put("|");
					for j in 1..9 loop
						if j = 4 then
							put("|");
						end if;
						if j = 7 then
							put("|");
						end if;
						put(board(i,j), width=>2);
					end loop;
					put("|");
					new_line;
				end loop;
				put("+------+------+------+");
				new_line;
				
				Put_Line("Enter a .txt file to create a solution document");
				Get_Line(outFile, last2);
				new_line;
				
				--Writes to the file output at the end
				create(outfp, out_file, outFile(1..last2));
				put_line(outfp ,"Solved Sudoku: ");
				put_line(outfp, " ");
				put_line(outfp, "+------+------+------+");
				for i in 1..9 loop
					if i = 4 then
						put_line(outfp, "+------+------+------+");
					elsif i = 7 then
						put_line(outfp, "+------+------+------+");
					end if;
					put(outfp, "|");
					for j in 1..9 loop
						if j = 4 then
							put(outfp, "|");
						end if;
						if j = 7 then
							put(outfp, "|");
						end if;
						put(outfp, board(i,j), width=>2);
					end loop;
					put(outfp, "|");
					put_line(outfp, " ");
				end loop;
				put(outfp, "+------+------+------+");
				
				Put_line("File Creation was a success!");
				close(outfp);
				return;
			else	
				for x in 1..9 loop
					for y in 1..9 loop
						--Finds open spots in grid
						if board(x,y) = 0 then
							i := x;
							j := y;
							--Used in place of a continue statement
							goto continue;
						end if;
					end loop;
				end loop;
				<<continue>>
			
				--Gets all the possible entries
				pA := entries(board, i, j);

				--Recursively call possible combinations
				for x in 1..9 loop
					if pA(x) /= 0 then
						board(i,j) := pA(x);
						solve(board);
					end if;
				end loop;
			end if;
			
			--Reset if there is a mistake
			board(i,j) := 0;
	
	end solve;

	begin
		Put_Line("Enter the .txt file you'd like to input");
		Get_Line(fileName,last);
		new_line;
			
		-- Opens File
		open(infp, in_file, fileName(1..last));
		j := 1;	
		
		--Reads in file, fills in array
		loop
			exit when end_of_file(infp);
			get(infp, fromFile);
			for i in 1..9 loop
				num(j,i) := character'pos(fromFile(i)) - 48;
			end loop;		
			j := j + 1;		
		end loop;
		
		--Prints out original sudoku array
		put("Original Unsolved Sudoku:");
		new_line;
		put("+------+------+------+");
		new_line;
		for i in 1..9 loop
			if i = 4 then
				put("+------+------+------+");
				new_line;
			elsif i = 7 then
				put("+------+------+------+");
				new_line;
			end if;
			put("|");
			for j in 1..9 loop
				if j = 4 then
					put("|");
				end if;
				if j = 7 then
					put("|");
				end if;
				put(num(i,j), width=>2);
			end loop;
			put("|");
			new_line;
		end loop;
		put("+------+------+------+");
		new_line;
		
		--Checks if the puzzle is solvable
		if(isTrue(num)) then
			--Calls the recursive backtracking solve method
			solve(num);
		end if;
		
		close(infp);

end Sudoku;
