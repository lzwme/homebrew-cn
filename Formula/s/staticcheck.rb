class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https:staticcheck.dev"
  url "https:github.comdominikhgo-toolsarchiverefstags2025.1.tar.gz"
  sha256 "314e7858de2bc35f7c8ded8537cecf323baf944e657d7075c0d70af9bb3e6d47"
  license "MIT"
  revision 2
  head "https:github.comdominikhgo-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e7f6fe45223ef01c310834e4f879a7c6e6b80b348ab96406b8d918a3151ca14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e7f6fe45223ef01c310834e4f879a7c6e6b80b348ab96406b8d918a3151ca14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e7f6fe45223ef01c310834e4f879a7c6e6b80b348ab96406b8d918a3151ca14"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e586d4cf482096aceb131f8fd22740e4c1a4d654ebdf785274479a87d64f247"
    sha256 cellar: :any_skip_relocation, ventura:       "5e586d4cf482096aceb131f8fd22740e4c1a4d654ebdf785274479a87d64f247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46771f9be661baa5fe1db4049c3f0475b95250267f3e662bf7ec4d0a8e598a44"
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