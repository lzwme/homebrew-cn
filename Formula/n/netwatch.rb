class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "f64ed60a7b5fb67679b7eb24ffedc1a20ab80546e588c8b943c06cd2e7fd0900"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "01a5cfd1feaac94113a753f69df29a72dd885177c57824ee71b7c4287401f5b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eeaf405603340e82854c329bf3bb70b7740e8f92afef3253346079bb7cfdc21e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c0afe496537b1d4afdd110dd0bac9e32b240d9b43317df89a06112d4b41bb18"
    sha256 cellar: :any,                 arm64_linux:       "bc27153014d92341348afb7e491c43f8b1ae86a9129a989ec0c5a6a9aeb46f13"
    sha256 cellar: :any,                 x86_64_linux:      "ba4474efda9b91e692730f098a14b0c2af93af0bff0eb6d291bafde46b5d3b93"
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