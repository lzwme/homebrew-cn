class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "9f1504998c9ac6951a9e75a7f7265c90d15fe033aca00952ac67b17873e893a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81a87f65d224aaae4d0b001006edf39e644317febf49a702646b1cf237d90039"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "adac9a18398836b483575f88af81fb77f7f3ecc54a2355579b2272ce798cdcb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "435b639213711ddba1e43fcc55712339a257eb8a641ab8a8327e708e37bb0b60"
    sha256 cellar: :any,                 arm64_linux:       "488cadbc410e24d3e6d36593c17d8c6af44752be00bbae82f16bec7a1f63dc92"
    sha256 cellar: :any,                 x86_64_linux:      "598b1af33864484649b0efa4cccb773a01a9a44dbcced15a1b91ddf4baf20177"
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