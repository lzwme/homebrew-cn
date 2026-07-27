class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "fd2f094a06e13aea0e79c28da1c5dd9386859a2988e13aa783e2fe4e7a32489f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "405630e51244f50d3d9dcc36a50d8416195b05f1f1c2d07b022ef81bce95805f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98eae466a064afd64f047df5133382cd9517824bc4bc850d6a986248b0bf6387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41f806b630aff7d8f51df081d321b96c2af1a65aa40810b2ed466b898066779e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d89f2b3aa405364cbc1ef34b6d8c691d24f91227812eac29fac4a87e902312d9"
    sha256 cellar: :any,                 arm64_linux:   "ca9dfcfd6bc081305d22ae879e0b23e96a424f01dedc642ef169c44eb60884bb"
    sha256 cellar: :any,                 x86_64_linux:  "16674dfd439a163de7dae016b7fdb35772ed7b3ad00ec5b4f816b46261de6c51"
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