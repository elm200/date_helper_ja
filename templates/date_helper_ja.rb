# Install date_helper_ja plugin
plugin "date_helper_ja", :git => "git://github.com/elm200/date_helper_ja.git"

# Scaffold
generate "scaffold User name:string date_of_birth:date date_of_birth_ja_long_era:date date_of_birth_ja_short_era:date date_of_birth_alphabet_era:date"
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
    <%= f.date_select :date_of_birth %>
  </p>
  <p>
    <%= f.label :date_of_birth_ja_long_era %><br />
    <%= f.date_select :date_of_birth_ja_long_era, :use_era_name => true %>
  </p>
  <p>
    <%= f.label :date_of_birth_ja_short_era %><br />
    <%= f.date_select :date_of_birth_ja_short_era, :use_era_name => true, :era_format => :ja_short %>
  </p>
  <p>
    <%= f.label :date_of_birth_alphabet_era %><br />
    <%= f.date_select :date_of_birth_alphabet_era, :use_era_name => true, :era_format => :alphabet %>
  </p>
  <p>
    <%= f.submit "Create" %>
  </p>
<% end %>

<%= link_to 'Back', users_path %>
}

# Replace users/edit view
file "app/views/users/edit.html.erb",
%q{<h1>Editing user</h1>

<% form_for(@user) do |f| %>
  <%= f.error_messages %>

  <p>
    <%= f.label :name %><br />
    <%= f.text_field :name %>
  </p>
  <p>
    <%= f.label :date_of_birth %><br />
    <%= f.date_select :date_of_birth %>
  </p>
  <p>
    <%= f.label :date_of_birth_ja_long_era %><br />
    <%= f.date_select :date_of_birth_ja_long_era, :use_era_name => true %>
  </p>
  <p>
    <%= f.label :date_of_birth_ja_short_era %><br />
    <%= f.date_select :date_of_birth_ja_short_era, :use_era_name => true, :era_format => :ja_short %>
  </p>
  <p>
    <%= f.label :date_of_birth_alphabet_era %><br />
    <%= f.date_select :date_of_birth_alphabet_era, :use_era_name => true, :era_format => :alphabet %>
  </p>
  <p>
    <%= f.submit "Update" %>
  </p>
<% end %>

<%= link_to 'Show', @user %> |
<%= link_to 'Back', users_path %>
}