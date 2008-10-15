configatron.mack.notifier.sendmail_settings.set_default(:location, '/usr/sbin/sendmail')
configatron.mack.notifier.sendmail_settings.set_default(:arguments, '-i -t')
configatron.mack.notifier.smtp_settings.set_default(:address, 'localhost')
configatron.mack.notifier.smtp_settings.set_default(:port, 25)
configatron.mack.notifier.smtp_settings.set_default(:domain, 'localhost.localdomain')
configatron.mack.notifier.set_default(:deliver_with, (Mack.env == "test" ? "test" : "smtp"))
configatron.mack.notifier.set_default(:adapter, 'tmail')

# xmpp settings
configatron.mack.notifier.xmpp_settings.set_default(:jid, 'h_test@jabber80.com')
configatron.mack.notifier.xmpp_settings.set_default(:jid_resource, 'work')
configatron.mack.notifier.xmpp_settings.set_default(:password, 'test1234')
configatron.mack.notifier.xmpp_settings.set_default(:host, 'http://www.foo.com')
configatron.mack.notifier.xmpp_settings.set_default(:buddy_list, [])