class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://ghfast.top/https://github.com/matthart1983/syswatch/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6c3b8b120fa79816d493359f74db412012b8225c8d761cb6a3af48b491d66c4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fa0fdbaeb376470681c9a1e7f1f3e9e5ef670ef51ad225d504033790c44dcd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5925e317839fc0d0b56c8fdea62c21dd6bbc4e2692b8c54e244ff51989ac28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a3d387f27bdbbad544f75e495e0a7021e4faee3016d6bcc441cbb42050b260"
    sha256 cellar: :any,                 arm64_linux:   "67cd111114480b71a56d7ef7c21a71be7e23e63871d1dcfae9c634a36934492d"
    sha256 cellar: :any,                 x86_64_linux:  "37bc4b660c8ed98391eb2abcd6f834592b0b16874270883c9831cf5338256529"
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