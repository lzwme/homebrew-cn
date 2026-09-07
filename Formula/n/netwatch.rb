class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "95dfbbf1208806d383bf8309ff40ec29fc55e1081ecd7c41ee8f110c8aa32227"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f356ef218d239e836571f037a98eb842b763709713ba3c234ca5bfdb34c46a0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b706b4834361112ef8616b5c4a36ecce5ad412c31042ae0992f9fc9f4e8f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a103c5b47d9a906a19827ac0a054a2fc0c61332cef9dddc10ba33fac265d71"
    sha256 cellar: :any,                 arm64_linux:   "33a10047b20231d759323b9b99473d8b4abd9713181694293fe01fc927218b5b"
    sha256 cellar: :any,                 x86_64_linux:  "c2b947d896a7b4aefb30edf09c7f7a87b6700cb9808e15f56e4fbddf417be3f4"
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