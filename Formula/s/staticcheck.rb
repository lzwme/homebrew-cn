class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https:staticcheck.io"
  url "https:github.comdominikhgo-toolsarchiverefstags2025.1.tar.gz"
  sha256 "314e7858de2bc35f7c8ded8537cecf323baf944e657d7075c0d70af9bb3e6d47"
  license "MIT"
  head "https:github.comdominikhgo-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a33d598d3c16a97c5f35d7dc119ffa09c6e0d61a9ac14202b3950973662f426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a33d598d3c16a97c5f35d7dc119ffa09c6e0d61a9ac14202b3950973662f426"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a33d598d3c16a97c5f35d7dc119ffa09c6e0d61a9ac14202b3950973662f426"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fa57ad4e8d1cb85df1007bceadae0adf738b284bfd6d082b1b7c54ba4647ed2"
    sha256 cellar: :any_skip_relocation, ventura:       "0fa57ad4e8d1cb85df1007bceadae0adf738b284bfd6d082b1b7c54ba4647ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "269e235e17c0ce6af1449717bba09d2d737d86a395915ea055478d3ff1a88268"
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