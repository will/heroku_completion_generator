require 'rubygems'
require 'heroku/command'
require 'erb'

def argument_for_option(option)
  name,attrs = option
  l = "--#{attrs[:long].split(/\s/).first}"
  d = attrs[:desc].gsub('"','\"')
  arg = attrs[:long] =~ /\s/ ? ':' : ''
  if attrs[:short]
    s = "-#{attrs[:short]}"
    "'(#{s} #{l})'{#{s},#{l}}\"[#{d}]#{arg}\" \\"
  else
    "'#{l}[#{d}]#{arg}' \\"
  end
end


Heroku::Command.load
commands = Heroku::Command.commands#.select{|k,v| k[0] == 'a'}
commands.each do |(_,cmd)|
   cmd.merge! safe_name: cmd[:command].gsub(':','\:')
   #cmd.merge! summary: cmd[:summary].gsub(/'/,"") if cmd[:summary]
   cmd[:options].each do |opt|
     opt.last.merge! arg_string: argument_for_option(opt)
   end
end

template = ERB.new(<<-EOF, 0, '>')
#compdef heroku
_heroku() {

local -a app_argument
app_argument=('(-a --app)'{-a,--app}'[application name]:')

_heroku_commands() {
  local -a commands
  commands=(
  <% commands.each do |(name,cmd)| %>
    "<%= cmd[:safe_name] %>:<%= cmd[:summary] %>"
  <% end %>
  )
  _describe -t commands 'heroku command' commands
}

<% commands.each do |(name,cmd)| %>
_heroku-<%= name %>() {
  _arguments \\
  <% cmd[:options].each do |(_,opt)| %>
  <%= opt[:arg_string] %>

  <% end %>
  $app_argument && ret=0
}

<% end %>
local curcontext=$curcontext ret=1
local context state line
declare -A opt_args
_arguments -C \
  '*::arg:->cmd' && return
case $state in
  (cmd)
    if (( $CURRENT == 1 )); then
      _heroku_commands
    else
      curcontext="${curcontext%:*:*}:heroku-$words[1]:"
      _call_function ret _heroku-$words[1]
    fi
    ;;
esac
}
_heroku
EOF

puts template.result(binding)
