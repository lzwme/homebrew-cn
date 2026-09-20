class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "5dd7907dbc57ff46c36a652e96af7743d67320c9a82205ec95b0f90f097c7c14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3acd349465f927f0a5e0eed73fd3b1bb3928842431a7e136273c5230cb4e7045"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9f11ce31b6cf562306ecd770dbb78d8d05ecb223477730ff2e3524f03e8e4b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "589e8525c71b2f46434ed679bcd018ea063fc906ad03b1535f1337edecdd2302"
    sha256 cellar: :any,                 arm64_linux:       "08a0fc0dd982923c2fe245a6df95ef90ad05a1202d0ccfc2852b1a371fec4efd"
    sha256 cellar: :any,                 x86_64_linux:      "9e5c8d4832f51798688c140e8c6fabafd5fc902a1d4da9ce925e2ecf7fc860de"
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
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end