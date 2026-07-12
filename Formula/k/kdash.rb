class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash-rs.github.io/"
  url "https://ghfast.top/https://github.com/kdash-rs/kdash/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "100632212c63ce79b5a2ad8b97af4ac1739c14c2fba19afe9b084fd403ad5ff3"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f3903845c8209e066b0ea634d91cc7fd2b16636e6dab6c1b9dfafa042a4834a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bba487c8425018a20fe03af17fc45e5cc2a6a694a2799c8e60ae81b2a8898a1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6db7af8d2b2a02425295d6ab24a21317a55a24c73324bc745bbd5b0a138a9ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e5e1053f8021c4f220286d7e79df32228a948f6ebdc8aaa38c9a050cd75808a"
    sha256 cellar: :any,                 arm64_linux:   "146bc8e41b6e9515174ac63cef766bccecff0b6591eab5275a27710baa9d23ea"
    sha256 cellar: :any,                 x86_64_linux:  "d64a58f8d6542cd48d44a81a1baab535de6823c8517698ee2672a6f3fe091a9c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdash --version")

    require "pty"
    output_log = (testpath/"output.log")
    r, w, pid = PTY.spawn("#{bin}/kdash", [:out, :err] => output_log.to_s)
    r.winsize = [80, 130]
    w.write "\e[80;130R"
    sleep 1
    r.close
    w.close
    output = output_log.read.gsub(%r{\e\[[\d;?]*[ -/]*[@-~]}, "")
    assert_match "Active Context", output
    assert_match "Resources", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end