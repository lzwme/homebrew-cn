class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://ghfast.top/https://github.com/matthart1983/netwatch/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "7c01bd6d6a9ba8d46a3e20921f53f5ee16166c4ed9b0b6243377d47b6974a39b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0887e230781c3617d6bc590d74cb220d99ad9991be5e8bfae5ed66563ea451fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aa45ab6a9ee0eec3ac733d51225c3fbe66e9d70417aac33d732723654968844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c96c35f11d8dc99c89723b87bbb4a678c31aee926d1d68ae9c96a8c83e95ab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "da6ce706b98e0ddb4f5e3c812a8080488c7892e1315dc6d2b8ecd4237f14c5e4"
    sha256 cellar: :any,                 arm64_linux:   "21aa429d84dd11c9a43a3aef6e249f38fba52f6b7d8be5b624fd34cde2af5aa4"
    sha256 cellar: :any,                 x86_64_linux:  "b2ee2f1c39439d687adffcfed42f2f85cce4b8f33eec79d46b3717a2d38eab7c"
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
      sleep 2 if OS.mac? && Hardware::CPU.intel?
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