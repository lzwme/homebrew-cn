class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "db428f9a85b930a37da33e2bd3ff9dd13c867de3e222e70a20c29e2fd3d5378e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0dd81626457cdb2ba7f45d42695f7df22b3d83dd702f550231da6ce0f4977de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0e5ac812a2dcdf733c48783dfcd4da6bbb80ddb0ff712b7f6ccb33605f0a038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bd43454e200b499c53261d18719c6233dc27c7c1322e1100f5e2ee8b013b9b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2aacc59e7d8b89fbb6995723a53fd78d855e1dfe8d9054f82b51e9cb4b928cf"
    sha256 cellar: :any,                 arm64_linux:   "740c913d0ed5464d769c91c01a7ac0636d547b7e21e4c642e0f3d9aa99bd9533"
    sha256 cellar: :any,                 x86_64_linux:  "524bbf75c5904def0c32e2b8d6023ac94f7adfa6d076ddbec60db4619d8da227"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.ansi") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/netwatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "Topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end