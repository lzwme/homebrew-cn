class Tccplus < Formula
  desc "Grantremove accessibility permissions to any app"
  homepage "https:github.comjslegendretccplus"
  url "https:github.comjslegendretccplusreleasesdownload1.0tccplus.zip"
  sha256 "b5a7861c7319df0200caf477a0d3bcd00385fb2cf5ca572bc9ad78ec6f7cce23"

  def install
    bin.install Dir["*"]
  end
end