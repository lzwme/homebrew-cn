class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghproxy.com/https://github.com/burrowers/garble/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "26e001eb469c9357c2a5212ee295da3c588b7f36b1ce0b7e7b92b8e6d44f0cd1"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4b58f8b5dd4ac18d64d0380a0e2c0fda72bfecc7c9e730cd8a390ec2326e529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4b58f8b5dd4ac18d64d0380a0e2c0fda72bfecc7c9e730cd8a390ec2326e529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4b58f8b5dd4ac18d64d0380a0e2c0fda72bfecc7c9e730cd8a390ec2326e529"
    sha256 cellar: :any_skip_relocation, ventura:        "ba22a32eebf8c56d3347401e8aceb9ddc76f0ad05f01eeaf330b1b74c6c496aa"
    sha256 cellar: :any_skip_relocation, monterey:       "ba22a32eebf8c56d3347401e8aceb9ddc76f0ad05f01eeaf330b1b74c6c496aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba22a32eebf8c56d3347401e8aceb9ddc76f0ad05f01eeaf330b1b74c6c496aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deb8dd3296bbb92ac22ae64c205a846cfa97631661dbc705be56d6d055355a1d"
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