class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://ghfast.top/https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 9
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "203a8630e3547cab39fc9421feb6b5b4f08005db00b722065716b4b457b3d2fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "203a8630e3547cab39fc9421feb6b5b4f08005db00b722065716b4b457b3d2fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203a8630e3547cab39fc9421feb6b5b4f08005db00b722065716b4b457b3d2fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca57806d987a488ef930a2e4992dfd8686e20e09bce4916ed147af2f55ff6cc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe7c30f1137820a68b20013c99aca181a8d747d9176861f842369b9b81ee6782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c5f55ac26ded348d7b192dc77e9257151ef9b94547a18be076f7df58714aca8"
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