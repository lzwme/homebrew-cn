class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "27cfa869f22d903e40b481ab61a60a9679afccbee5b622439243be4ebf722958"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ec2bf215de33d5dd1ee68e5cd05343aa30baacdb09320ac12b3c396c50d5999"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c33d1b59ff0d472eace18e0141f093951a041bc6bed97c8c68e1d6e331de7f17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47487126f9399acb285fae8a7f3ff9303ba0a44051e61fa0ed4c8d0f4592a23d"
    sha256 cellar: :any,                 arm64_linux:       "1c9413276a35564338492d74d42b13e882e74e9bb815998add5b6fce4e16032d"
    sha256 cellar: :any,                 x86_64_linux:      "a9f5c8df63a6ad7bab88173d110e5435b1e91ec6eafaadd79a880502cdd0e224"
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