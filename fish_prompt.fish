# name: cyan
set -g cyan (set_color 33FFFF)
set -g yellow (set_color CCFF00)
set -g red (set_color -o red)
set -g green (set_color -o green)
set -g white (set_color -o white)
set -g blue (set_color -o blue)
set -g magenta (set_color -o magenta)
set -g normal (set_color normal)
set -g purple (set_color -o purple)

set -g FISH_GIT_PROMPT_ADDED "$green●$normal"
set -g FISH_GIT_PROMPT_MODIFIED "$yellow●$normal"
set -g FISH_GIT_PROMPT_DELETED "$purple●$normal"
set -g FISH_GIT_PROMPT_RENAMED "$blue●$normal"
set -g FISH_GIT_PROMPT_UNMERGED "$yellow●$normal"
set -g FISH_GIT_PROMPT_UNTRACKED "$red●$normal"
set -g FISH_GIT_PROMPT_CLEAN ""

function _git_status -d "git repo status about Untracked, new file and so on."
    if [ (command git rev-parse --git-dir ^/dev/null) ]
        if [ (command git status | grep -c "working directory clean") -eq 1 ]
            echo "$FISH_GIT_PROMPT_CLEAN"
        else
            if [ (command git status | grep -c "Untracked files:") -ne 0 ]
                set output $FISH_GIT_PROMPT_UNTRACKED
            end
            if [ (command git status | grep -c "new file:") -ne 0 ]
                set output "$output$FISH_GIT_PROMPT_ADDED"
            end
            if [ (command git status | grep -c "renamed:") -ne 0 ]
                set output "$output$FISH_GIT_PROMPT_RENAMED"
            end
            if [ (command git status | grep -c "modified:") -ne 0 ]
                set output "$output$FISH_GIT_PROMPT_MODIFIED"
            end
            if [ (command git status | grep -c "deleted:") -ne 0 ]
                set output "$output$FISH_GIT_PROMPT_DELETED"
            end
            echo $output
        end
    end
end

function _git_branch_name -d "Display current branch's name"
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function fish_prompt
    set -l last_cmd_status $status
    set -l cwd $magenta(basename (prompt_pwd))
    if [ (command git rev-parse --git-dir ^/dev/null) ]
        set -l git_branch $cyan(_git_branch_name)
        set -l git_status (_git_status)
        set git_info "$cyan [$git_branch$git_status$cyan]"
    end

    #echo -n -s $normal $magenta (whoami) '@' $normal $yellow (hostname -s) $normal ' ' $cwd $git_info 
    echo -n -s $normal $cwd $cyan $git_info

    set fish ' ➜ '
    if test $last_cmd_status -eq 0 
        echo -n -s $green $fish $normal
    else
        echo -n -s $red $fish $normal 
    end

end
