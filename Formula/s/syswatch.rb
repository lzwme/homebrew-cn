class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://netwatchlabs.com"
  url "https://ghfast.top/https://github.com/matthart1983/syswatch/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "1d2d3dda0f2017474953c6c7bbaea898021ea8aa5d82db9baf1b5462e6279a06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01d41e7581efb71e7e292fd77a2d13d291645f057f7420e96603477c450d3b38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723f14eaa7b2eeaaa63d96c74213463da3e7e69be4286af92ab5ca3a3cd60023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3329b7605d7c835112274d8bf4ef0692d16f08adb3e0063b48aa245ce4c41647"
    sha256 cellar: :any,                 arm64_linux:   "ca135fcf8504b5413e6343b80bbc6cbdd2c041a7441fb53a17af5ecadcd7e4b8"
    sha256 cellar: :any,                 x86_64_linux:  "5157369b921cf789115c901be9e4744530b65db808941d7d399e94fbff61eabe"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on arch: :arm64 # test fails on Intel macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.txt") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/syswatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.txt").read
    assert_match "Services", screenlog
    # match text in help dialog
    assert_match "Procs tab", screenlog
  end
end