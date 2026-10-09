class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.22.7.tar.gz"
  sha256 "c6bb423d0547b563345482817b3cad7cbd25cbce68dcf9123375ecdbbedf445d"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5ff4b9f58c25544fcb4368c03b2b2ab7fe4e027b3cd9cdecb0cf54ed319c930e"
    sha256 cellar: :any, arm64_tahoe:       "b77aa3add48b98cc0e4573db76155c17972df88b537a7ca743417d3227803f55"
    sha256 cellar: :any, arm64_sequoia:     "45bd4307c08ed25f4f19d7d5ed7e64606808d7284d59a73c777d7ef8f7b87387"
    sha256 cellar: :any, arm64_linux:       "5c987a662ea3c0a2f41b48a2c975393692e1a5e4b6aface24d944ba59df06da3"
    sha256 cellar: :any, x86_64_linux:      "e40051fe56a350062c623b2ce9d8565ba2161927251a7e113067234501a39818"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"mdfried", testpath/"test.md", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/mdfried #{testpath}/test.md", [:out, :err] => output_log.to_s).last
    end
    sleep 3
    assert_match "Detecting supported graphics protocols...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end