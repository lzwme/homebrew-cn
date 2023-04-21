class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/v4.0.11110.tar.gz"
  sha256 "d3a048cd938247db7078e3eea8827b5351771f0d45b5b39777ebae279fed88de"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "380054ce4e713cfdd61171f36f92aa1e251979720e834ad676125b3493d35970"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6dfdd23ffb30fd1674a904bc2ab7ff3899c5dd486f2cb2eb97d0cf4d246a838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11dce90050db54ebb199562aa0112aeffbdac8a4e0fab09093c4a63966ce6343"
    sha256 cellar: :any_skip_relocation, ventura:        "1d344ed23241280908cb07b1ea2885e6a76544fd3767a659e47ca931362ed875"
    sha256 cellar: :any_skip_relocation, monterey:       "b380af3065cfa7ba6844fce79f80ace30196fa45a31a47f994fdb6c46ab5a365"
    sha256 cellar: :any_skip_relocation, big_sur:        "46f59641813e28110a7886161f6b565493284b0f799726214aca72557107362a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa8efde4cda76e2940bc64d8084da5282928cbdaa429e92ad0981aa323c58b9a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end