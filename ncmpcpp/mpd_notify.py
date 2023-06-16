#!/usr/bin/env python3
# -*- coding: UTF8 -*-

import gi
import notify2
from gi.repository import GLib
from mpd import MPDClient

client = MPDClient()
client.timeout = 10
client.idletimeout = None
client.connect("localhost", 6600)

mpd_song = MPDClient.currentsong(client)

s_artist = mpd_song['artist']
s_title = mpd_song['title']
s_album = mpd_song['album']

s_notification = s_artist + " - " + s_title + " - (" + s_album +")"

notify2.init("Music Player Demon")
show_song = notify2.Notification("Music Player Demon", s_notification,
    icon="/usr/share/icons/Adwaita/scalable/emblems/emblem-music-symbolic.svg")

show_song.set_hint("transient", True)

show_song.show()

