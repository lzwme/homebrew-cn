class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghfast.top/https://github.com/burrowers/garble/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "aea6e0a172296b50e3671a9b753aeb2eb7080a3103575cdf5e4d1aeccfe14ede"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbcc54a78762a37d6ce38d3697e08abdf910f9e4353dcfe116a2b0fd707cecea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbcc54a78762a37d6ce38d3697e08abdf910f9e4353dcfe116a2b0fd707cecea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbcc54a78762a37d6ce38d3697e08abdf910f9e4353dcfe116a2b0fd707cecea"
    sha256 cellar: :any_skip_relocation, sonoma:        "23d0fe32e99b6949a0937b904da3c8b3e2c9dd1f7139850296f41c58d741738f"
    sha256 cellar: :any_skip_relocation, ventura:       "23d0fe32e99b6949a0937b904da3c8b3e2c9dd1f7139850296f41c58d741738f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c56bb272699827a82d36b5420ba881a8b9bb1ea554ebaab5af4d7ea0369582"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO
    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end