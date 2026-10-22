class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "1c4450923fc0d0f075d8a1d8097f2d565670a19a159149f197f4fb373175c9d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "875eb13a7726ef013349c5dd12489ae8f554811ac1cd98a048c2fb4d0fc8b8cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11473c1f0accd8623cd775bebdd93680755e022f202c2c230db66368dc39592a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45df13201c5a555891ee5844eddec78b822d2f23ffb06bd81b5591e982ff6635"
    sha256 cellar: :any,                 arm64_linux:       "777ec4cf662d75d62023f3d58ee196b982d909b3f258a1993d7ec5fee0a8c07e"
    sha256 cellar: :any,                 x86_64_linux:      "d00df47f4cdcb718737c7eeef60074dd3f262e80bc13a8e434fcd613e9bf5186"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

    screenlog = (testpath/"screenlog.ansi").binread
    assert_match "topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end