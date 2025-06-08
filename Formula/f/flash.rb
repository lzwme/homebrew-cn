class Flash < Formula
  desc "Command-line script to flash SD card images of any kind"
  homepage "https:github.comhypriotflash"
  url "https:github.comhypriotflashreleasesdownload2.7.2flash"
  sha256 "571d9e6424b275859a9273029a2321245888ab201dbae1a3ec57a6ef708adce1"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7ba28ca5b0372393c667b70b7841d4b9b6f587e9ce0c0c1a6bf9bb67dddec577"
  end

  def install
    bin.install "flash"
  end

  test do
    cp test_fixtures("test.dmg.gz"), "test.dmg.gz"
    system "gunzip", "test.dmg"
    output = shell_output("echo foo | #{bin}flash --device devdisk42 test.dmg", 1)
    assert_match "Please answer yes or no.", output
  end
end