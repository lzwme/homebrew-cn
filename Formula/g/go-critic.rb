class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://ghfast.top/https://github.com/go-critic/go-critic/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "766fda194d4c22313f4285f214804a1f1689bc4795fc3cc176395f171223c226"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d96d411bb8443fd9e953830816853257d78fe6dafcaeefac8bea1af229ca896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d96d411bb8443fd9e953830816853257d78fe6dafcaeefac8bea1af229ca896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d96d411bb8443fd9e953830816853257d78fe6dafcaeefac8bea1af229ca896"
    sha256 cellar: :any_skip_relocation, sonoma:        "8320f485b3d0c146ebfd8d62ee6437e7aadd3df79a11413215f20423ac29a296"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abf405e4cb927e20c1fa1e4bd2f0a23ef143dfda6e76445c3266e633c2b6b2e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae572be6466bfbf21f82790cba0ba2f49507af81589db9c8a72f35bc0cbc6b3f"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" if build.stable?
    system "go", "build", *std_go_args(ldflags:, output: bin/"gocritic"), "./cmd/gocritic"
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    GO

    output = shell_output("#{bin}/gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output
  end
end