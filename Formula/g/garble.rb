class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghproxy.com/https://github.com/burrowers/garble/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "355e0ee7e98b1656fcfe8156040ed2ef41afd5e2f2d6332465392ab425530494"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ca7cacf31cdfd1b84b80070621419c71e4c6cf22a2da893d935d50e70cf7183"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8626463363e920d3b36c000b6eb9015ad9682d5937078744c21b6cae5d5266e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69e2c4e0d00129061b6498ef802e13d6064533180e3d99d5ff36e4b7a49b36fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "41deef2a97fbf15eaab5e244ae460c51f0b70f3dc8c1a08d8109653faa73bd85"
    sha256 cellar: :any_skip_relocation, ventura:        "4261aaa514d189b58921ce8e561b311e57311c62ff5402b9dc6c6f24a8e28703"
    sha256 cellar: :any_skip_relocation, monterey:       "ee295efb0c4f93944a798529203ebbe3d845527175494fc1ca37e8e3792b47ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ec75a2ba723217ac76a484335de41940aa8530754e760ed620b886147cbf20"
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