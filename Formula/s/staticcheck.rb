class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://ghfast.top/https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 6
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d49bf15d445037e7338411d4834b502f31b2d48d61b2307d68bc6ab0cf06e9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d49bf15d445037e7338411d4834b502f31b2d48d61b2307d68bc6ab0cf06e9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d49bf15d445037e7338411d4834b502f31b2d48d61b2307d68bc6ab0cf06e9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c0672275fc93e3a7f80af0f80ff1619c03102f4a0fcf2a82d2d65ae2b9b3d0d"
    sha256 cellar: :any_skip_relocation, ventura:       "4c0672275fc93e3a7f80af0f80ff1619c03102f4a0fcf2a82d2d65ae2b9b3d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e00e861c054c592f87ecd10ef2f26f59cd611ca71f26fe7d7ba6ceab3b4d13"
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