if status is-interactive
	
  #Use starship
	starship init fish | source

	alias pamcan pacman
	alias q 'qs -c ii'
    # Commands to run in interactive sessions can go here
end
