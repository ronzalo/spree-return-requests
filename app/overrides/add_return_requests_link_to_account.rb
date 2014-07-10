Deface::Override.new(
  :virtual_path => "spree/users/show",
  :name => "add_return_requests_link_to_account",
  :insert_after => "dl#user-info",
  :text => "<%= link_to 'Devoluciones', spree.return_requests_path %>",
  :disabled => false
)