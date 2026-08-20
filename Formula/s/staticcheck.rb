class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://ghfast.top/https://github.com/dominikh/go-tools/archive/refs/tags/2026.1.tar.gz"
  sha256 "4b20d65194e5462264c784f2968de65fcd7aba8e9efa37aa9b1fadc13b29699b"
  license "MIT"
  revision 7
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dee41c4f96b677ea0c790d6f431e77f773bfd8ca36db8e3cad6ad83affadca6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dee41c4f96b677ea0c790d6f431e77f773bfd8ca36db8e3cad6ad83affadca6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dee41c4f96b677ea0c790d6f431e77f773bfd8ca36db8e3cad6ad83affadca6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "73b1a4af55b1c8b0173a9ac5a88e8977973f5097eb22024e55c09968a63da4ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bde991e13e6fb8619e798ca59d3863e22f3c9dc9002863c1e5d35a126a57fe3"
    sha256 cellar: :any,                 x86_64_linux:  "c353d6d6f6a21941ead8efd5d11aa72a0ae49ab8878ffff2a5bd1f5a37217b5c"
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