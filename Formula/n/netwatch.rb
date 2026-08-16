class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "0490e129af6820b5b7be24e662efc660a1d5aab9f7d00c383b8ab1ff26b032a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55b53e54c5b74ff6c45bd5c40e687e7f710da4d43698e1c96c674cb35b6dbe76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b705eb82ca167fe08342cbdea2f8486722b0fd67f99ab9fb398a85fa5deab59a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f0b9b7bd19c422fe8741a2174f315b54c53db60caed24b026287dacadb278dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c833616e6ac9dddbd7090f8bb997d22d21ebf9f6b85e820ea82f214677f9f485"
    sha256 cellar: :any,                 arm64_linux:   "cf3277bdb203d3699b8e0aa22bb2f6edd13d6331056e27d1a3196b67ed17206e"
    sha256 cellar: :any,                 x86_64_linux:  "c34448d73a403fd9b0c33bfb94f732d56224a3a0a6d4c751db48403514f4360d"
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