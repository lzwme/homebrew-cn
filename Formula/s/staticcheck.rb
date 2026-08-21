class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://ghfast.top/https://github.com/dominikh/go-tools/archive/refs/tags/2026.2.tar.gz"
  sha256 "72fa00a4bef32ab52aa3ca916e70108ca021ef3c35dda555350c0b670c432033"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "714d8638ed69e7f83023a0bd57e39998bd55d7ff0f3a9a7c63359c3d3e01c724"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "714d8638ed69e7f83023a0bd57e39998bd55d7ff0f3a9a7c63359c3d3e01c724"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "714d8638ed69e7f83023a0bd57e39998bd55d7ff0f3a9a7c63359c3d3e01c724"
    sha256 cellar: :any_skip_relocation, sonoma:        "f702bddddb5c4fd8b7337527fec308e14079aa60cd15f2a0ff34bf1fa31f8adc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57505375410e126724116d448ac3619b7c59c0d535155c275a631a460509d64a"
    sha256 cellar: :any,                 x86_64_linux:  "adcc0990b3f14d9cd61ee369f60fcebdfe96279f6f401c7259c9953e58420f76"
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