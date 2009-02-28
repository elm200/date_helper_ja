# Install date_helper_ja plugin
plugin "date_helper_ja", :git => "git://github.com/elm200/date_helper_ja.git"

# Scaffold
generate "scaffold User name:string date_of_birth:date"
rake "db:migrate"

# Routing
route "map.root :controller => 'users'"
run "rm public/index.html"

# Replace users/new view
file "app/views/users/new.html.erb",
%q{<h1>New user</h1>

<% form_for(@user) do |f| %>
  <%= f.error_messages %>

  <p>
    <%= f.label :name %><br />
    <%= f.text_field :name %>
  </p>
  <p>
    <%= f.label :date_of_birth %><br />
    <%= f.date_select :date_of_birth, :use_era_name => true %><br />
    <%= f.date_select :date_of_birth, :use_era_name => true, :era_format => :ja_short %><br />
    <%= f.date_select :date_of_birth, :use_era_name => true, :era_format => :alphabet %><br />
  </p>
  <p>
    <%= f.submit "Create" %>
  </p>
<% end %>

<%= link_to 'Back', users_path %>
}