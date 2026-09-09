class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "c9750e43571c8d307aeb93a913ec3123ce64225c07060d17949c91ae83584932"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00930ea0244db753e21e6af2a6518e1d4bee4ee7ca0fd5de9cff6b8ef484cf7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "835a97e51738eaf8aa09ca6156be26995667c2e8a49c18ecfb9d3cabde3d2830"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56970c5fb4c64061d235c0c6610511ac0c50f3092f2251f8b0c288c4497cefce"
    sha256 cellar: :any,                 arm64_linux:   "34659969298184cebe5407b6f4b1479e2ce9702e9b25509c28d1462f2d978c84"
    sha256 cellar: :any,                 x86_64_linux:  "092bec61f06161418f98cd3b6a990a5ca7286739d99a5d34c5291a9a805c3eaf"
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