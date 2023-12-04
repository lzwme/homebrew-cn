class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghproxy.com/https://github.com/burrowers/garble/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "355e0ee7e98b1656fcfe8156040ed2ef41afd5e2f2d6332465392ab425530494"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56098770c6779ff88aab32c7efd3add8609965a7db91bb915885527ce6c4e737"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b44e7149273c910fdc4d64deb7dde768d72edfe62ea538ac87bb38394c7acb51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d62b067b725d9110060bca99e77d6ff54bd4918252618b4beaacb8d61f6e67b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "763150a065d9adc3cc8b7179f36df1f85d5da73a01451c93e9713266e7f95d8d"
    sha256 cellar: :any_skip_relocation, ventura:        "5dc2d126faecf3bea71bb6cb32aa50626ac04be08955ec55899a072f604276ee"
    sha256 cellar: :any_skip_relocation, monterey:       "14d8c51991cef311df3238abe822afbb161a4b8b7600c0ea127fcf1a9331c35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8febe0dffd6fd4e9a6b13af8cc212bfbcb03b0d77592f25a79290eb1a1e6a013"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internal/linker/linker.go", "\"git\"", "\"#{Formula["git"].opt_bin}/git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
           CGO_ENABLED 1
                GOARCH #{goarch}
                  GOOS #{goos}
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end