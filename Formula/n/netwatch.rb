class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "1d9b962f1353eeb3243506a8f52fc63676eddcbb4be30db26c738b4b1b1a6cfc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04f3cfa2f88dd4c6d02944c5d76c9e538bca54a3a68cab0476c6a47b2422ee2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7629a29479795a42b58bdbe314d1015467acbd91b2e4d39f72680e88affaf68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9efc6ff0acd1d3fb3dfdad14ee7f2f2ba4e941f7e4719f299bd198dad6d40bd1"
    sha256 cellar: :any,                 arm64_linux:       "c6ba1def8a5de48b3601dc4a33dcf3f16f1bfdb885f24c8df1b69b9c3b74e529"
    sha256 cellar: :any,                 x86_64_linux:      "060b8e144671907bdf28728a5dfe9d6ac1749d2c516fea6692cc01114e328df9"
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