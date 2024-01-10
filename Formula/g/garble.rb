class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https:github.comburrowersgarble"
  url "https:github.comburrowersgarblearchiverefstagsv0.11.0.tar.gz"
  sha256 "355e0ee7e98b1656fcfe8156040ed2ef41afd5e2f2d6332465392ab425530494"
  license "BSD-3-Clause"
  revision 2
  head "https:github.comburrowersgarble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "297faf930a649a3225067fb63e0f948830782324b4b124469d9ea1cf3ddbca66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2803262d284397b078bd919d369bec741b3c12aac1f563c32939f6cca8e9cd08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80d93dc8bb0690a69af5c63691293dab3047d9dfeea05a162e38b3820973b374"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ae5245128e2236f049b0ef36d758c36a72a8f3070431668bc4f505c3bd4cc90"
    sha256 cellar: :any_skip_relocation, ventura:        "aa94dd9dbdceb46e63bb72ac1645fcb050256d2756716f6e1bb91163d9c35637"
    sha256 cellar: :any_skip_relocation, monterey:       "fcf8125dc2680bb44dab1eb013c65124e6eb00142e0815e90ba3bb8522830a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68b41e825b0d5d679c59fb08ac88f59e3b7bdde03f4251ee8dfa8c96566291ac"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internallinkerlinker.go", "\"git\"", "\"#{Formula["git"].opt_bin}git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    system bin"garble", "-literals", "-tiny", "build", testpath"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}hello")

    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp
    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
           CGO_ENABLED 1
                GOARCH #{goarch}
                  GOOS #{goos}
    EOS
    assert_match expected, shell_output("#{bin}garble version")
  end
end