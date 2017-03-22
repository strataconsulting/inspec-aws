describe users.where({ 'has_console_password?' => true }) do
	its('entries.length') { should cmp 1 }
  #its('is_mfa_enabled?') { should be true }
end