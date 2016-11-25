# Buddy
A robot friend who wants to know how your day was.

# Usage

Root access is needed for storing logs and for `watcher.rb` to run `arp-scan -l`.

```
bundle install
sudo mkdir /run/buddy
sudo eye load buddy.eye
sudo eye info
sudo eye stop buddy
```
