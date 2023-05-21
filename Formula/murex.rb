class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://ghproxy.com/https://github.com/lmorg/murex/archive/refs/tags/v4.1.6140.tar.gz"
  sha256 "34dc05a4f8e50ac4213c82cb91352715d1f0168a19003ce0afc18274ab046071"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "973b62511e94bf0327cc98a77b23c89bb28cd6685d1368c9b6a440621ecd78dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f303619f251e4b9597fc4b03e856636b3b65080619a378476f9860da68f01fad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "128800f54adb21a65f38569e693aedfbc39a0d2936a28e802745d3533f232147"
    sha256 cellar: :any_skip_relocation, ventura:        "30c3f0c5558ceb65988fff9b7e3404c37e7d0a41713f21ebdc3b6e4d7f7b033a"
    sha256 cellar: :any_skip_relocation, monterey:       "4c20bee520b97385d3a4a0df438b2c2bd2383636677f6327601ef8cf7272ead5"
    sha256 cellar: :any_skip_relocation, big_sur:        "690902f6c4b9f5cc57564505852d1857af473e4ee6ba052fabc3618086b718a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00b90eacb5b8aeca9872534dede9bd3d71033ae6166ca5ed1c83221537bca15"
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