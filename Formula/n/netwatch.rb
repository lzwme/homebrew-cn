class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "e67ba46ba7bebc4914c34a4f5a1a22f3d3e57bd6bdb07ec035667cd1751e968a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf5a800579b4f95770190a4e1cb34f6a1d91b56226b25acf318a010f1921fde0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75fe80c0ef01e80197987d7583671b0896ec2bf3f03f4e45d2cb439f171ee4c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b39228c31e30e7be477a7d5a4e7595d0177f9ac96aa9d3566f1bb069b6047e8c"
    sha256 cellar: :any,                 arm64_linux:       "13d8fbce9e1868146ee2abad171e35d4938d32bf24ba74c50a0c341d0e410f4c"
    sha256 cellar: :any,                 x86_64_linux:      "cf46621dbdab8113893d7359d025a4efaf7a1e2a5654e53bc986d696df2c5a30"
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