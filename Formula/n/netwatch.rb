class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "6bd60b65ecd4575b887a09276ce36b2c24c0758c44de0378dce4d08065c39b8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c56534c225a61435283dd6845e51a9e50436cedf8557182a0ae1ee47f17560c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4327246e7bac032169b7948db08d919e5854756ce9117a9f120ea082fef58e67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00c6502dad31c462a5eae1ac97ae46f8fdf7bd4b2f486d0eb90b74a15021d037"
    sha256 cellar: :any,                 arm64_linux:       "a67af26f7ccde41f01ca2e20b8f36e808563af2b579f9747548ab4d9859b60e5"
    sha256 cellar: :any,                 x86_64_linux:      "bdd739e74354a906c908bdecf37948275aa76b1cff449e1317f4e22f4f1d675f"
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