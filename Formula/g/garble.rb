class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https:github.comburrowersgarble"
  url "https:github.comburrowersgarblearchiverefstagsv0.12.0.tar.gz"
  sha256 "cf18939683a9e453468e8dd1bcc0da5b1bb4b306e6cc5bf935e0c5c8d68b5d35"
  license "BSD-3-Clause"
  head "https:github.comburrowersgarble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f0b40df0f7a548a5d60c3cccb60e682117eaae467a86f0e4f50c00c09b52882"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fcbb46ca194653ad647b2a78cc8c398818cb5027849d79001889ce15115c2f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e380a26a97da73aff6b517cac08513697916a0f2e92a266b20dbb11206a5f9b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b2731f19af5354716ae207a69c59c51a0edfaa7d2a6f75fb8cd3ae03d1a9df9"
    sha256 cellar: :any_skip_relocation, ventura:        "9c71616ff3e44cf3966bd0f29e04ff60059cf7ef065136b32a9445e87936e424"
    sha256 cellar: :any_skip_relocation, monterey:       "072e36f943c57a2abf1024cc70a60f55fdd2b46e1bcbd8a9623a270a865c9481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e652b925eb4f3191832277b6e11b5b3fd7b26d84fe792f9ed9d4ca81200348e8"
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