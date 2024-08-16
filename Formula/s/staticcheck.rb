class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https:staticcheck.io"
  url "https:github.comdominikhgo-toolsarchiverefstags2024.1.1.tar.gz"
  sha256 "fa0e5305e91ef126ac7de52c99a04728255fc694d45b0a9a3f1ca026a44828bf"
  license "MIT"
  head "https:github.comdominikhgo-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "131765987b0f12c51386e6218eaa1b891591be901ae20a74cab49fca603c9493"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "facb63338994f8f96b3f3c7c5f985d86dcc83388019ce456532c66aefab7ce2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fe87448cadc09dcaa29aed7b90eb7885beafe267e7969ee633845fc8217a8e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "94e925f03077234e103db2f1c6856c2d82091cddd002413254ff963707106af5"
    sha256 cellar: :any_skip_relocation, ventura:        "d94a6a1faaf4618c7c86242c241781937911a0877b81e2c4cf9178728dfb8c55"
    sha256 cellar: :any_skip_relocation, monterey:       "6ff15d299b646342cf9ceb8a30aa9737904cebf55d2a3bf8f952ba32bc395229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18b1177996332a42f55a560a66418557181fd2fd169e356ceb920183ae5f3e01"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, ".cmdstaticcheck"
  end

  test do
    (testpath"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    EOS
    json_output = JSON.parse(shell_output("#{bin}staticcheck -f json test.go", 1))
    assert_equal json_output["code"], "S1021"
  end
end