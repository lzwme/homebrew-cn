class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https:github.comburrowersgarble"
  url "https:github.comburrowersgarblearchiverefstagsv0.11.0.tar.gz"
  sha256 "355e0ee7e98b1656fcfe8156040ed2ef41afd5e2f2d6332465392ab425530494"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comburrowersgarble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21f5d99252a907319439202db0f421f30c519c223df38e9a58e64b116728b114"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc04e6bcaf8927029277f5ba56de3b5af2efaf43ae4d049642a3a881ab14c12d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f3e2a53df3656f47f61c27b2b5959ce1237ec45143bce2c67fd381a30e510d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ca1b340d6ffbb8ab42af164a622194c2fe9a8f20f48a7f965aa19f644840fec"
    sha256 cellar: :any_skip_relocation, ventura:        "20066676cbe0b6d21e0402be28ac100a26be1b429ae321f3c4ae315521c100d6"
    sha256 cellar: :any_skip_relocation, monterey:       "5fef49561ae5f71ca7652aa8f6e26a9d11611ac9191b4588760f16cd5f7605b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0156c4c46684c4cdf970e1142bb2dad6bd4f5ceae1bf9c3c2b4f6206549022ad"
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