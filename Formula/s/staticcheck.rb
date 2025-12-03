class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://ghfast.top/https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 11
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51133b84e20aa3d2295fb85e04b8812fcb5bae200adda0c1abc9c48de2a32eb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51133b84e20aa3d2295fb85e04b8812fcb5bae200adda0c1abc9c48de2a32eb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51133b84e20aa3d2295fb85e04b8812fcb5bae200adda0c1abc9c48de2a32eb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "17dec85804bf3247643d6d8d45b9318497e8154414dfe81f5807d87ef2bc4941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ffe4c7a9cd5ea6fadb127cde6b78a9554e7d641f346f7a5e0cd152b9f053265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307a08710779d94bdea89a81b4ebf6bf7b68d3a2c6394badd7380bfcc1f70ef6"
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