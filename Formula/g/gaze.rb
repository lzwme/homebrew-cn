class Gaze < Formula
  desc "Execute commands for you"
  homepage "https:github.comwtetsugaze"
  url "https:github.comwtetsugazearchiverefstagsv1.2.0.tar.gz"
  sha256 "d5aec83c31e892acb8ee2c2e04a80d4a465ef76253391d4047b9de161b869868"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bad9012985c147353807f307eceb3637b79520c6631c015b8b6b695583be96d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bad9012985c147353807f307eceb3637b79520c6631c015b8b6b695583be96d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bad9012985c147353807f307eceb3637b79520c6631c015b8b6b695583be96d"
    sha256 cellar: :any_skip_relocation, sonoma:        "10d94693513e71beca63ac0ba9da572831d2763f665fc86b1d5be7a4723e8fa8"
    sha256 cellar: :any_skip_relocation, ventura:       "10d94693513e71beca63ac0ba9da572831d2763f665fc86b1d5be7a4723e8fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40d765ab4b2954432d9cc23f3c551d02e2290da5cfd1225db0db62df90cfccf6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmdgazemain.go"
  end

  test do
    pid = fork do
      exec bin"gaze", "-c", "cp test.txt out.txt", "test.txt"
    end
    sleep 5
    File.write("test.txt", "hello, world!")
    sleep 2
    Process.kill("TERM", pid)
    assert_match("hello, world!", File.read("out.txt"))
  end
end