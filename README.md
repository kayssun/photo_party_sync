# PhotoPartySync

PhotoPartySync is a small gem that scans for given sd cards in the network and downloads all available images to
your local machine.

# Why?

For example at a wedding or a party you give out some wireless sd cards to your guests. They put them in their cameras
and all their photos at the event will be collected by one computer which can display them in a slideshow.

This slideshow is not part of this gem. I plan to publish my implementation later here on github.

## Requirements

You need an sd card compatible with the "Toshiba Flash Air" card. These need to be preconfigured to log into
your existing access point.

## Installation

    $ gem install photo_party_sync

## Usage

Run

    $ photo_party_sync --help

to get a list of options. You need to know the IP address of your sd card(s). Run

    $ photo_party_sync --card <ip>

to let the script check for a card. It can take a while for the card to login into your network. If you have
multiple cards, you can add all of them to a text file and supply this file to photo_party_sync.

    $ photo_party_sync --card-file <filename>

The parameter --watch will let the script keep polling all cards and download all new images once the appear.

    $ photo_party_sync --card <ip> --watch

**HINT:** You can add all your cards addresses to your host file (/etc/hosts on Linux/Mac) to have nice names for them.
 These names can be used in the card parameter or the list file. This is especially helpful since photo_party_sync uses
 these names as folders to separate the images.

## Contributing

1. Fork it ( https://github.com/kayssun/photo_party_sync/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
