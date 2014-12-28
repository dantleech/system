#  Project: lnotify
#  Description: A libnotify script for weechat. Uses
#  subprocess.call to execute notify-send with arguments.
#  Author: kevr <kevr@nixcode.us>
#  License: GPL3
#
# 0.1.2
# added option to display weechat's icon by tomboy64
#
# 0.1.3
# changed the way that icon to WeeChat notification is specified.
# (No absolute path is needed)
# /usr/bin/notify-send isn't needed anymore.
# (pynotify is handling notifications now)
# changed the way that lnotify works. When using gnome 3, every new
# notification was creating a new notification instance. The way that
# it is now, all WeeChat notifications are in a group (that have the
# WeeChat icon and have WeeChat name).
# Got report that it has better look for KDE users too.
#
# 0.1.4
# change hook_print callback argument type of displayed/highlight
# (WeeChat >= 1.0)
#
# 0.2.0
# - changed entire system to hook_process_hashtable calls to notify-send
# - also changed the configuration option names and methods
# Note: If you want pynotify, refer to the 'notify.py' weechat script
import weechat as weechat
import pynotify

lnotify_name = "lnotify"
lnotify_version = "0.2.0"
lnotify_license = "GPL3"

# convenient table checking for bools
true = { "on": True, "off": False }

# declare this here, will be global config() object
# but is initialized in __main__
cfg = None

class config(object):
    def __init__(self):
        # default options for lnotify
        self.opts = {
            "highlight": "on",
            "query": "on",
            "notify_away": "off",
            "icon": "weechat",
            "truncate": "50"
        }

        self.init_config()
        self.check_config()

    def init_config(self):
        for opt, value in self.opts.items():
            temp = weechat.config_get_plugin(opt)
            if not len(temp):
                weechat.config_set_plugin(opt, value)

    def check_config(self):
        for opt in self.opts:
            self.opts[opt] = weechat.config_get_plugin(opt)

    def __getitem__(self, key):
        return self.opts[key]

def printc(msg):
    weechat.prnt("", msg)

def handle_msg(data, pbuffer, date, tags, displayed, highlight, prefix, message):
    highlight = bool(highlight) and cfg["highlight"]
    query = true[cfg["query"]]
    notify_away = true[cfg["notify_away"]]
    buffer_type = weechat.buffer_get_string(pbuffer, "localvar_type")
    away = weechat.buffer_get_string(pbuffer, "localvar_away")

    # do not report people entering / leaving
    if prefix == '-->' or prefix == '<--':
        return weechat.WEECHAT_RC_OK

    if prefix == '--':
        return weechat.WEECHAT_RC_OK

# if pbuffer == weechat.current_buffer():
#        return weechat.WEECHAT_RC_OK
#
#    if away and not notify_away:
#        return weechat.WEECHAT_RC_OK

    buffer_name = weechat.buffer_get_string(pbuffer, "short_name")

    # truncate if too long
    message = (message[:cfg['truncate']] + '..') if len(message) > cfg['truncate'] else message

    if buffer_type == "private" and query:
        notify_user(buffer_name, message)
    elif buffer_type == "channel" and highlight:
        notify_user("{} @ {}".format(prefix, buffer_name), message)
    elif buffer_type == "channel":
        notify_user("{} @ {}".format(prefix, buffer_name), message)

    return weechat.WEECHAT_RC_OK

def notify_user(origin, message):
    n = pynotify.Notification(origin, message, cfg['icon'])
    n.show()

    return weechat.WEECHAT_RC_OK

# execute initializations in order
if __name__ == "__main__":
    weechat.register(lnotify_name, "kevr", lnotify_version, lnotify_license,
        "{} - A libnotify script for weechat".format(lnotify_name), "", "")

    pynotify.init('weechat')
    cfg = config()
    print_hook = weechat.hook_print("", "", "", 1, "handle_msg", "")
