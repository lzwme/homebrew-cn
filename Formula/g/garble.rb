class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghfast.top/https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "478cc034cdfa77b43228eb068c893dbd18af7d98722131e34a850eac9a96ea80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "478cc034cdfa77b43228eb068c893dbd18af7d98722131e34a850eac9a96ea80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "478cc034cdfa77b43228eb068c893dbd18af7d98722131e34a850eac9a96ea80"
    sha256 cellar: :any_skip_relocation, sonoma:        "90dfb72aff843be2ff7beba6d14b037373c3c2d7b916f9aedff33cdd7631edc6"
    sha256 cellar: :any_skip_relocation, ventura:       "90dfb72aff843be2ff7beba6d14b037373c3c2d7b916f9aedff33cdd7631edc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e79ee6c0faa37f313a099561ba5b314fcfbe51300cb0fa68d0777313bfb320"
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