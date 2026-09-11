class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "b29c80c20702d05bc4551a79893fe438d1d2f6091525c06fd571fe6a90e9e69b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "216574db1c9473d2fb914923cbc26904fbdcdef40b05a872f81fae2bd2c644de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7cb1212310d224f4279bef10f81fdcb8e6cac5c4d9a42190ebd7a25f176131c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba33d4beebe713cad8e5f6bea2be1e73e9ec4bb07c02006d2201ad6a351b6540"
    sha256 cellar: :any,                 arm64_linux:       "deac149de2b29f8668306307a1d662269cef8d64602bc2b1433a5fdeedf9ec8b"
    sha256 cellar: :any,                 x86_64_linux:      "6424b5fa5ce0dc1f735abe990485ae2208cc5ec33e171e62d9979625ffef6da4"
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