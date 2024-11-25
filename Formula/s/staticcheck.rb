class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https:staticcheck.io"
  url "https:github.comdominikhgo-toolsarchiverefstags2024.1.1.tar.gz"
  sha256 "fa0e5305e91ef126ac7de52c99a04728255fc694d45b0a9a3f1ca026a44828bf"
  license "MIT"
  revision 2
  head "https:github.comdominikhgo-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa7a84f0f1cdaee74ad2754d0f655f7c74f0c903d3e8f295cc0c58134efa6c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa7a84f0f1cdaee74ad2754d0f655f7c74f0c903d3e8f295cc0c58134efa6c4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa7a84f0f1cdaee74ad2754d0f655f7c74f0c903d3e8f295cc0c58134efa6c4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2488084eaa458d13d998e7eb42fb3dcaed91bc3dc6c9b5062f2df7a7313587b8"
    sha256 cellar: :any_skip_relocation, ventura:       "2488084eaa458d13d998e7eb42fb3dcaed91bc3dc6c9b5062f2df7a7313587b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a71589c51aa0587e5b143e2fccde456a316e24398acf6456aac62dc70884ec16"
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