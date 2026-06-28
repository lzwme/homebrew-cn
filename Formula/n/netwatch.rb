class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.9.tar.gz"
  sha256 "d6ab3fefe9b64689579519fe7507cdeb571dcb6a44b9f63b447d3f25b37eabe0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d26d83f4f67d1cfeadd22b423efb2e1ec4c84fe0ff8a93f1bf3474203afa930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c97b52b5cb19312fe0ecd85d3d6e9d1b841537c4f6af3b9500677da95f1c618f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2121df60bcd72b6aad2caa653fd84b0938b1bfded454b3b52f03438e760a49de"
    sha256 cellar: :any_skip_relocation, sonoma:        "9219f08dded735df31e8e2e1709e1c31578146d87665870f36a6a9627c3e4557"
    sha256 cellar: :any,                 arm64_linux:   "35e4da604b985ddf430456dc1d87da17b033b9df265a0d11f0f0419663b80a47"
    sha256 cellar: :any,                 x86_64_linux:  "02ce36ee9074b034266f62e37ea914c98922ad4dca221f66488b34461a969e80"
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
    assert_match "Topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end