class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https:staticcheck.io"
  url "https:github.comdominikhgo-toolsarchiverefstags2024.1.1.tar.gz"
  sha256 "fa0e5305e91ef126ac7de52c99a04728255fc694d45b0a9a3f1ca026a44828bf"
  license "MIT"
  revision 3
  head "https:github.comdominikhgo-tools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8187b25f32028c83b3716a0ec6ef55d5f30e39b0ca8ba7544fbdd1c655943b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8187b25f32028c83b3716a0ec6ef55d5f30e39b0ca8ba7544fbdd1c655943b66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8187b25f32028c83b3716a0ec6ef55d5f30e39b0ca8ba7544fbdd1c655943b66"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f785fff421a523b484b32c2f2f5dd515c7c333585a23783dc169e528aa4c46a"
    sha256 cellar: :any_skip_relocation, ventura:       "1f785fff421a523b484b32c2f2f5dd515c7c333585a23783dc169e528aa4c46a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f5fbb90cc9ea2befec5985bdaca13452b48eb99d010ad3286e18f7e07be0d30"
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