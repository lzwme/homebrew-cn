class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://ghfast.top/https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 13
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d16284edd1b880e61e0e6bd7425e4d8a13433b5f36e84e7d09c72673deea3e2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d16284edd1b880e61e0e6bd7425e4d8a13433b5f36e84e7d09c72673deea3e2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d16284edd1b880e61e0e6bd7425e4d8a13433b5f36e84e7d09c72673deea3e2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "100e36800e3dc6256514202c0b0e37c71e5493a56b1df4c584a37c935f345ce7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e985ebede25ea39703ab0ee9f6e33baa723075542686674a54b5014a7086e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d19170a884621c071268c63c3ec46ef58ba66aa9a695ad4e8f0f45cce1c969"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/staticcheck"
  end

  test do
    system "go", "mod", "init", "brewtest"
    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    GO
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json .", 1))
    refute_match "but Staticcheck was built with", json_output["message"]
    assert_equal "S1021", json_output["code"]
  end
end