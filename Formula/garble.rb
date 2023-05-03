class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghproxy.com/https://github.com/burrowers/garble/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "26e001eb469c9357c2a5212ee295da3c588b7f36b1ce0b7e7b92b8e6d44f0cd1"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8e99bff1195617bdfc4952b1dc42913a1a12fdf7d0eafdd54d9f37f8db54e65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8e99bff1195617bdfc4952b1dc42913a1a12fdf7d0eafdd54d9f37f8db54e65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8e99bff1195617bdfc4952b1dc42913a1a12fdf7d0eafdd54d9f37f8db54e65"
    sha256 cellar: :any_skip_relocation, ventura:        "ee6453fb1894e8ab04a98abf64de3ec9ecae92c8dba256b617faf63978ba8a39"
    sha256 cellar: :any_skip_relocation, monterey:       "ee6453fb1894e8ab04a98abf64de3ec9ecae92c8dba256b617faf63978ba8a39"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee6453fb1894e8ab04a98abf64de3ec9ecae92c8dba256b617faf63978ba8a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90cec08c40208a4ce3498c9ff2e75c772131bf5604af9b2d780ddd28d62206a4"
  end

  depends_on "go" => [:build, :test]

  def install
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