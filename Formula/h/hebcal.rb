class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://hebcal.github.io/"
  url "https://ghfast.top/https://github.com/hebcal/hebcal/archive/refs/tags/v5.13.0.tar.gz"
  sha256 "1c0a4f4d1987aedbc0a5e611b9491ce790594aa081390820586f9f168cb5aa53"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6649fa02cb1de30080cb1318283db8a804578c590649a1d88fd1986be97889bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6649fa02cb1de30080cb1318283db8a804578c590649a1d88fd1986be97889bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6649fa02cb1de30080cb1318283db8a804578c590649a1d88fd1986be97889bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "647693b77d206d8d9b4faa3597cc4b3f466d7512032498a148a034fde5a42a72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bc8c26345ad345fce2cb65d4ca3e1f73f1b1502ad7e7f33a76966fa3f2be5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "906af09af456c9bd0981b8b29ff65bf9f6eab2be44db5b5bd0b1819d3ec60f7f"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end