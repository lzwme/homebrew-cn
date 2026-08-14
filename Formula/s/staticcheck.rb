class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://ghfast.top/https://github.com/dominikh/go-tools/archive/refs/tags/2026.1.tar.gz"
  sha256 "4b20d65194e5462264c784f2968de65fcd7aba8e9efa37aa9b1fadc13b29699b"
  license "MIT"
  revision 6
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76705c756eca6299c2163c0c0fe833944f905613d4015ab225476171222582a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76705c756eca6299c2163c0c0fe833944f905613d4015ab225476171222582a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76705c756eca6299c2163c0c0fe833944f905613d4015ab225476171222582a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "34575a2bad6559d547dae826a6c492db9e430238792a459807b58da1528352a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd65425bb7bd58d0e6e4c5d30123f41ccbb5055776aecd2326ab66db9b71e0f6"
    sha256 cellar: :any,                 x86_64_linux:  "6d5c8a6cebc31df69538173497a592e087183be9e2746c51d5b96bad4ad89697"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "./cmd/staticcheck"
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