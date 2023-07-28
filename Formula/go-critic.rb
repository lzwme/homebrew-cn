class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://ghproxy.com/https://github.com/go-critic/go-critic/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "2cd0a27ef0beb9377714957d80b8f9927648ee5e0279bf56e30154efc72faf8b"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a458aef7ae221ccc5347a9a840a4c80b1929ffa25dbe14af55fa02708ffaa4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a458aef7ae221ccc5347a9a840a4c80b1929ffa25dbe14af55fa02708ffaa4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a458aef7ae221ccc5347a9a840a4c80b1929ffa25dbe14af55fa02708ffaa4b"
    sha256 cellar: :any_skip_relocation, ventura:        "ac13b3294f1514ca697d4f4aa9aaeb1b0b844d6c060727f49609a2dcd6dea187"
    sha256 cellar: :any_skip_relocation, monterey:       "ac13b3294f1514ca697d4f4aa9aaeb1b0b844d6c060727f49609a2dcd6dea187"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac13b3294f1514ca697d4f4aa9aaeb1b0b844d6c060727f49609a2dcd6dea187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12b74a9ccfd8a914bfa476b68ba2a876f78f04c066f54533116a7cc2d3ccc9db"
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