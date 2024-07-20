class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https:murex.rocks"
  url "https:github.comlmorgmurexarchiverefstagsv6.2.3000.tar.gz"
  sha256 "46d82853d5c81169e8c398541e372ef0898b6ef3c221c4c14df5def573b4c8c6"
  license "GPL-2.0-only"
  head "https:github.comlmorgmurex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55b1ceaff3bf7d3cdf9f2664d6ec1aef162488a8f3f8c1003ef35c8e58337db2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "958e3557dda2e1bc9dc9f4421fbf22a33709b1e39d4e4c28662f4af309d154c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86ad1ebaf26776c79bff11010b6418f854e3e9eb65318b7ad44cf4fcc85abf02"
    sha256 cellar: :any_skip_relocation, sonoma:         "12d681e63386e1c152987075d618a7bb50551aa752fbfce4bca745796d07d64b"
    sha256 cellar: :any_skip_relocation, ventura:        "98a83d25f3d0dcc20c7405a94433587aad23be3d519eb9ff905432710d493efa"
    sha256 cellar: :any_skip_relocation, monterey:       "e88841eabaeac44a23bc22bcd01e7ab60dba8e45d03466e8e5c2dfda0bdb0b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7611f0c696d18d7a3a47d4d1c4c0ea7e3608b9b849328ccc5e684c68b0c2802c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}murex -version")
  end
end