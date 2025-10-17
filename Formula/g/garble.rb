class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghfast.top/https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50dc5375aa554f9c1ade40548170ef3cce373c14cfef9c2f98e39eca42a03259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50dc5375aa554f9c1ade40548170ef3cce373c14cfef9c2f98e39eca42a03259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50dc5375aa554f9c1ade40548170ef3cce373c14cfef9c2f98e39eca42a03259"
    sha256 cellar: :any_skip_relocation, sonoma:        "635544bf59b37b6e6c10b0bfeecc60a72cf9f87b2a25036f917800d9ee949da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9729ab63df1c362fc140665dd662f76b7f1b56b2f89732ee2f0118aca92ede9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90ce5770a08e852f12994c7779cfcbe64c9c0905da241d493986c0bb2d44928"
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