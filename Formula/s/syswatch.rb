class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://ghfast.top/https://github.com/matthart1983/syswatch/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "c76f0f9f29044f6854edf5280533d0c560d3a52302c134dd37223e222cc86148"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b8c5a1f185bdc4a3927401d8a3d4c88d1cbde6d7747895d9e0743de9ffd9f75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6e5d1394f3b06418b657b04487d6327e9a510a7b807d0b628805ad76ec69328"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7cdad0285df290844cfebf5b88edfe92e896768a590beb5dd7603c73e25b5fa9"
    sha256 cellar: :any,                 arm64_linux:       "a2033119b94c264b659848bfcdb50321211ede0a0a541cb7dc75c72657d58502"
    sha256 cellar: :any,                 x86_64_linux:      "641b381b742a74b124f089fc799659351b86e016511b1645c43d5450b6d176b4"
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

    screenlog = (testpath/"screenlog.txt").read.scrub
    assert_match "Services", screenlog
    # match text in help dialog
    assert_match "Procs tab", screenlog
  end
end