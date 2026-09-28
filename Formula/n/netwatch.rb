class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.32.5.tar.gz"
  sha256 "1529c82484599c349d2936708e0ae74f2175a66736d424cd621187c7d202cca8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0536789150c6951b7a32acdc3abf2056600a0a70461d1730294afcd3aaf7f3d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f151459afef27bac974b54d69c65fb207f85be73e2dd52149372e35b9eeb2b0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f093aa8402698d1c0681e01ac984adb6ea527fbf5183681af769e5fdf9515bd9"
    sha256 cellar: :any,                 arm64_linux:       "f4b7cd1793a82f4769a887ae03bef717f8e4437f5d581b3a5fcd9d0b24aacf46"
    sha256 cellar: :any,                 x86_64_linux:      "7beff039906b70b505234c3b1553d4e1c50e356ce62ec3273ad61e627819e56a"
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

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end