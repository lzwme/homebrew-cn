class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://ghfast.top/https://github.com/matthart1983/syswatch/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "37371f3fe6db83dcc221b2b2d95fc2b8bd783955ef6d4e92dcb86944e71d8a90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b63edba10c18ab186633533f430d56a1ed2b14fb671ef326825753037ecda8df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da1ec0c83e975c9daeaa7ab4f50f0078be6e28ba5657bcb897c2257f4ec6c0e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55df9014711fb561eeeb09f8a602603e8534e036015a7a6ee1ba2c2bf3c99a4d"
    sha256 cellar: :any,                 arm64_linux:       "6b93def18c475f2147d20712b80c5550f8e77d8c1e3af809d98edbb6e7473415"
    sha256 cellar: :any,                 x86_64_linux:      "2fe904bf407d87a9285d2c2c27cf0b6c61d5b8196cad8cb8b76bdf135680aa21"
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

    screenlog = (testpath/"screenlog.txt").read.scrub
    assert_match "Services", screenlog
    # match text in help dialog
    assert_match "Procs tab", screenlog
  end
end