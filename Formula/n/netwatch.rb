class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "db9110535dfcde9ccb8736706465216932308499ab087f67e3f633decab32e04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c857c17f9eaa372f15b192f405996da3840aefd0d6214a4140d963d3d5ff9d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d0c3e2bd53408c3f69441b0235e050840be1d29b908d03f8c82e64ef7d0e136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eb49d81bb1b42ed3d87e5ec8ea2c253ceb78637d3d5b20d660e30e530c50a5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0199883936ec4377d64fb20c709d96e3c1df630ca8e347d330c9786c7255a0a3"
    sha256 cellar: :any,                 arm64_linux:   "3f6720078cff601c45d9ab61dd70ba4ff49d4027e601bde3e3c31ff1e87451e2"
    sha256 cellar: :any,                 x86_64_linux:  "638b53fb2bec0daa7a693fb09e6a7dc25574b8fa6af32a6b315e7dc33dea55c7"
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