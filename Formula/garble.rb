class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghproxy.com/https://github.com/burrowers/garble/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "11c038cb5fb6b21a2160305beec939c69b0712e39f52f0a0b6d977fa68d5b6db"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba0821114a58ed15fad34a23179486094526551826fbaa786e7a052b0e082b83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba0821114a58ed15fad34a23179486094526551826fbaa786e7a052b0e082b83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba0821114a58ed15fad34a23179486094526551826fbaa786e7a052b0e082b83"
    sha256 cellar: :any_skip_relocation, ventura:        "33139d9ab9315c532d1f0ae781daf536af3a4c98d8b006cf2de5845fe0167e79"
    sha256 cellar: :any_skip_relocation, monterey:       "33139d9ab9315c532d1f0ae781daf536af3a4c98d8b006cf2de5845fe0167e79"
    sha256 cellar: :any_skip_relocation, big_sur:        "33139d9ab9315c532d1f0ae781daf536af3a4c98d8b006cf2de5845fe0167e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "393639d2de0a92130ae75ebe3c6acec0901ed2cdbaac3ce081137e51791071bf"
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