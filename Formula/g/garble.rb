class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghfast.top/https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a723761caefd99a243ede0763f6e468988d17fae15a234591f4bc3d4951807e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a723761caefd99a243ede0763f6e468988d17fae15a234591f4bc3d4951807e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a723761caefd99a243ede0763f6e468988d17fae15a234591f4bc3d4951807e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e1b7789a134b3eb6d5d32dcf0957223adc2e711ef6b8e34edd53badb67c33bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbe1171298ffe0a1a7a17e252c37268f302cdb7d9984e678fa9f13921847a4d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e70170430bc876393c37e7080381b4b384b1b8d6b1475baa4e11c362ee1067"
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