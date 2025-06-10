class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https:github.commptrepick"
  url "https:github.commptrepickreleasesdownloadv4.0.0pick-4.0.0.tar.gz"
  sha256 "de768fd566fd4c7f7b630144c8120b779a61a8cd35898f0db42ba8af5131edca"
  license "MIT"
  head "https:github.commptrepick.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c5df3f1f792d5df3784e7d7e8204de908bb43f7ec0830bf576eedc58de28c683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf2e439d81bbe3a7cc2fadf74c2b22835087deb28ece7b39a05312372e551d86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baf0de992329c39e5c0ed64680c7fc8438e460ccb4a261e15a987e8afac5859e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3978f455a6bf9cba97b215e8a71a4f314eb48bfd0a920ef307e46c5c3bf3e186"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "032d06aa754000e281f773bb857266efc79e1762e8f689617778a19e17505688"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd88176ee4fec77b374b9f9ba8d948409232bc2c88d0ae4f140409ee0e79c92a"
    sha256 cellar: :any_skip_relocation, ventura:        "7d8ae03b4a23f8bbfba46552fac1bac70eb1d2bc80177660ce21ef4974438954"
    sha256 cellar: :any_skip_relocation, monterey:       "d9bfbabddcd3e479420308af573f56ac530386d110c95044a65e64f4ef7c8f28"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8da7b41b502c8c72b90fd41bf1570e840198fa6678cc5efca8a1c26a8d5557f"
    sha256 cellar: :any_skip_relocation, catalina:       "754879e53b48743051bb1571bb4b6180a415ac36af8deaf335f5c193326d232f"
    sha256 cellar: :any_skip_relocation, mojave:         "55596e8ab28fd4fc36d064f6395c38ce51314bcc0d2f2f3862515a683bc92182"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0fc521881c760d4f9e4f8625795716e0e1c0e1ed1522ccb5efd055313b2729bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a8633db6fbcdff4972f69dc32b3a304f117f00a1bae82122488c8294df775c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5c80628af5eda75fa3d34827529f3f482c0dc058c1016f5a6033deca9d22566"
  end

  uses_from_macos "ncurses"

  conflicts_with "nmh", because: "both install `pick` binaries"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man
    system ".configure"
    system "make", "install"
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin"pick") do |r, w, _pid|
      w.write "foo\nbar\nbaz\n\x04"
      sleep 1
      w.write "\n"
      begin
        assert_match(foo\r\nbar\r\nbaz\r\n\^D.*foo\r\n\z, r.read)
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end
  end
end