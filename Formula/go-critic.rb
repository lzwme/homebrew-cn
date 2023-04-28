class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://ghproxy.com/https://github.com/go-critic/go-critic/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "db0708ecfbd565362ca46ea33ba72f17e3311e2a9895e3557b56ee8e1b8e9d0b"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66cc3c840ff530c718e9f06f14940f4a3e105efce5968c020e810deae2fd2b5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66cc3c840ff530c718e9f06f14940f4a3e105efce5968c020e810deae2fd2b5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66cc3c840ff530c718e9f06f14940f4a3e105efce5968c020e810deae2fd2b5d"
    sha256 cellar: :any_skip_relocation, ventura:        "f06fb9258e8faf60fbd6698e65fb69ad87c6c3f9942e8879c44772975c160c44"
    sha256 cellar: :any_skip_relocation, monterey:       "f06fb9258e8faf60fbd6698e65fb69ad87c6c3f9942e8879c44772975c160c44"
    sha256 cellar: :any_skip_relocation, big_sur:        "f06fb9258e8faf60fbd6698e65fb69ad87c6c3f9942e8879c44772975c160c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5db59e2c59edb5547e6ac541d46188829ca7f1a7aaf0eb8991c49fdde5f0ea93"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"gocritic"), "./cmd/gocritic"
  end

  test do
    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    EOS

    output = shell_output("#{bin}/gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output
  end
end