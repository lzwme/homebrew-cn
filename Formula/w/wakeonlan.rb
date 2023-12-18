class Wakeonlan < Formula
  desc "Sends magic packets to wake up network-devices"
  homepage "https:github.comjpolivwakeonlan"
  url "https:github.comjpolivwakeonlanarchiverefstagsv0.42.tar.gz"
  sha256 "4f533f109f7f4294f6452b73227e2ce4d2aa81091cf6ae1f4fa2f87bad04a031"
  license "Artistic-1.0-Perl"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd7879b6d846df1d5a5186b6c05cde2207467aaf6e58a807012d7ac91a5b8ab3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f541c4803bb947fd8bec2daa1ff9ddcc5c1f7aab2f2b1952cbae99bacea30d8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f541c4803bb947fd8bec2daa1ff9ddcc5c1f7aab2f2b1952cbae99bacea30d8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd9429ee013c7d939887d72d5876a7f617855bc521f372a9d30dd393917e874d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd7879b6d846df1d5a5186b6c05cde2207467aaf6e58a807012d7ac91a5b8ab3"
    sha256 cellar: :any_skip_relocation, ventura:        "f541c4803bb947fd8bec2daa1ff9ddcc5c1f7aab2f2b1952cbae99bacea30d8c"
    sha256 cellar: :any_skip_relocation, monterey:       "f541c4803bb947fd8bec2daa1ff9ddcc5c1f7aab2f2b1952cbae99bacea30d8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd9429ee013c7d939887d72d5876a7f617855bc521f372a9d30dd393917e874d"
    sha256 cellar: :any_skip_relocation, catalina:       "a54812034696435a392dd80980cd74b56c8dc2bc30a5d001b679637a00ce6b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1e0c7185796fd30b6592b244bcd1032fa019667e0dbc5fe92ea9ececf842f75"
  end

  uses_from_macos "perl"

  def install
    system "perl", "Makefile.PL"
    system "make"
    bin.install "blibscriptwakeonlan"
    man1.install "blibman1wakeonlan.1"
  end

  test do
    system "#{bin}wakeonlan", "--version"
  end
end