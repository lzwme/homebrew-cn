class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://ghfast.top/https://github.com/matthart1983/syswatch/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "24b71363e9c089e892c2ea6a5d361b774240f57c228dd13d5a9e94253401435e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30e801ae83e5feff1bce87fa1c20be59c61fce60dce8e2f78fc76cb6a88ad84b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7551360ed03a1e2140182c8bf0569dca176712843e3583ecc445f1b74ad3efa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd28367332097e05b2aeb292113edf1f3a01c327872068cbdf269e05f8e2940d"
    sha256 cellar: :any,                 arm64_linux:   "b5601beaa0dda64b1f398f971aeac88f05297b6f74492748156b5a28d4c264ea"
    sha256 cellar: :any,                 x86_64_linux:  "abb89e2844c3a9e5619b18d33706f8796bca7592852adebee17fe22ddbd45db9"
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

    screenlog = (testpath/"screenlog.txt").read
    assert_match "Services", screenlog
    # match text in help dialog
    assert_match "Procs tab", screenlog
  end
end