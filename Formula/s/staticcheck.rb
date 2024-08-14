class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https:staticcheck.io"
  url "https:github.comdominikhgo-toolsarchiverefstags2024.1.tar.gz"
  sha256 "f7c68cbab0a46aff3af24de24d00a58744353aa7e99aa0b03ec208cd00248e0e"
  license "MIT"
  head "https:github.comdominikhgo-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd142f1f9caf45af94738d42afb56b4754f2c5fa1676147de03f536db73df015"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0c6ddd1e059cca595282b869ed61650391f82d6489616cbe3a1e02402da787a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65a2e85ac2a533e49c33e3a5ac671357cc55b38748f7120fd6be709278a7c363"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a854ff75ac43a5d5d05fa301335942282a7f404ae5279e5baed1d544d417677"
    sha256 cellar: :any_skip_relocation, ventura:        "6fa59fb95ebdeabb7048ef48541ea9cf21613ae520d0cc9fabc735e20beb5284"
    sha256 cellar: :any_skip_relocation, monterey:       "78b99c408e8bb50820816374f83df60b847c4469a898fa5ca32a8a33cc95a784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401196e23168df45c0f7117b42fcbcfa71216551be27693ac229155925ddde07"
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