configatron.mack.notifier.sendmail.set_default(:location, '/usr/sbin/sendmail')
configatron.mack.notifier.sendmail.set_default(:arguments, '-i -t')
configatron.mack.notifier.smtp.set_default(:address, 'localhost')
configatron.mack.notifier.smtp.set_default(:port, 25)
configatron.mack.notifier.smtp.set_default(:domain, 'localhost.localdomain')
configatron.mack.notifier.set_default(:deliver_with, (Mack.env == "test" ? "test" : "smtp"))
configatron.mack.notifier.set_default(:adapter, 'tmail')

# xmpp settings
configatron.mack.notifier.xmpp.set_default(:jid, 'h_test@jabber80.com')
configatron.mack.notifier.xmpp.set_default(:jid_resource, 'work')
configatron.mack.notifier.xmpp.set_default(:password, 'test1234')
configatron.mack.notifier.xmpp.set_default(:message_type, :chat)
configatron.mack.notifier.xmpp.set_default(:wait_for_response, true)
configatron.mack.notifier.xmpp.set_default(:response_wait_time, 20)
configatron.mack.notifier.xmpp.set_default(:response_message, "ack")
