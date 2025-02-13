class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https:github.comburrowersgarble"
  url "https:github.comburrowersgarblearchiverefstagsv0.14.1.tar.gz"
  sha256 "0eb231e6ad91793f0fcf086fb57a1654f0c2056284a79fb12ac955ade6791737"
  license "BSD-3-Clause"
  head "https:github.comburrowersgarble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f6c231be0fe7870ee79a9145748a531a5a8a6f646cc8378ed7ce10193a4b07a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f6c231be0fe7870ee79a9145748a531a5a8a6f646cc8378ed7ce10193a4b07a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f6c231be0fe7870ee79a9145748a531a5a8a6f646cc8378ed7ce10193a4b07a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb922347255628df364c15b261e8e3d2446ed7f2b3611681df5295ca7b86410d"
    sha256 cellar: :any_skip_relocation, ventura:       "bb922347255628df364c15b261e8e3d2446ed7f2b3611681df5295ca7b86410d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfadb7ca5285681fd936bb3a4a81959d5c05896c04690fc6e68ca2ed3101e1e8"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internallinkerlinker.go", "\"git\"", "\"#{Formula["git"].opt_bin}git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO
    system bin"garble", "-literals", "-tiny", "build", testpath"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}garble version")
  end
end