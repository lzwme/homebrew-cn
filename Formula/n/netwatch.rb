class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "9499c109dfb148ed5da79a9c0c6c5bc83672e7e7362af18efc31456c98528fed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "966a4b562bf0d1e907071d0517d0d4a9ec2d84502477a30dfba7de267b69c3cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76b3a8d635dea84400384e8a1ccdc9660c0dcd0f36dbad0e4e01dd6518d93f10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d3e1c12e8a79191c46f6029453d331ee324906e70202764f89d3cd9c2f33b63"
    sha256 cellar: :any,                 arm64_linux:       "99cfd25a8b5896a28520223961cd03d82b83f8bf5fec4e8cf78dadf9fc87e730"
    sha256 cellar: :any,                 x86_64_linux:      "a6fbf03318a8d82653a95f0390d7afd85e4fe39a143c94082b57d7b0b5438af1"
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