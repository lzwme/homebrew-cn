class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https:staticcheck.io"
  url "https:github.comdominikhgo-toolsarchiverefstags2024.1.1.tar.gz"
  sha256 "fa0e5305e91ef126ac7de52c99a04728255fc694d45b0a9a3f1ca026a44828bf"
  license "MIT"
  revision 3
  head "https:github.comdominikhgo-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc67553402f707912a62fd0273dd980bdfd1351e84bb2b7eb11bbf43d05de78c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc67553402f707912a62fd0273dd980bdfd1351e84bb2b7eb11bbf43d05de78c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc67553402f707912a62fd0273dd980bdfd1351e84bb2b7eb11bbf43d05de78c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac54e515dc925e3c01ff3ce9695c6443b60e748ad0e89202e41a117e3d2d168d"
    sha256 cellar: :any_skip_relocation, ventura:       "ac54e515dc925e3c01ff3ce9695c6443b60e748ad0e89202e41a117e3d2d168d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92556c3780241a1d87e3d1d067d9fb98d9c74d5a4d52740afbb58934f6a937fa"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, ".cmdstaticcheck"
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