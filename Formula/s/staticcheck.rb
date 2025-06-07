class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https:staticcheck.dev"
  url "https:github.comdominikhgo-toolsarchiverefstags2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 3
  head "https:github.comdominikhgo-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c90b2411f849db5cf6e99b5927aff6f9d31f1dbc684beae2e3a965e1f61e02c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c90b2411f849db5cf6e99b5927aff6f9d31f1dbc684beae2e3a965e1f61e02c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c90b2411f849db5cf6e99b5927aff6f9d31f1dbc684beae2e3a965e1f61e02c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "934c58bb900abdd91812f3ceca33d3a1a80cfe6295dd9cc9c6c412090b06f81f"
    sha256 cellar: :any_skip_relocation, ventura:       "934c58bb900abdd91812f3ceca33d3a1a80cfe6295dd9cc9c6c412090b06f81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "667bf55c540aa0a6bbd3aa9d34c15e68557831176885b6b9dfcc81aeea28dcaa"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdstaticcheck"
  end

  test do
    system "go", "mod", "init", "brewtest"
    (testpath"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    GO
    json_output = JSON.parse(shell_output("#{bin}staticcheck -f json .", 1))
    refute_match "but Staticcheck was built with", json_output["message"]
    assert_equal "S1021", json_output["code"]
  end
end