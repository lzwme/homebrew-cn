class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghproxy.com/https://github.com/burrowers/garble/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "11c038cb5fb6b21a2160305beec939c69b0712e39f52f0a0b6d977fa68d5b6db"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58e35ffe79f555bd43bf6a36d85b71923931fda5affb404f1e34797da6a93c13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4a4c82ef6c71d4d7e135d8c2a2d1bdd0fba35dcdfb37f0337e10818aeb2e822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "325dac8a9c354cba4942d846a3c44974742aabdbd52798b970b560e5925907ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bac0841f70a27e18e4c71dc31deb1f96aee19c55bed2a1172323870cae2d4ca"
    sha256 cellar: :any_skip_relocation, ventura:        "d9963b71d766de89a829227bc6dc6151bb03f0dfc7aaac8543ec3d0e83e605cd"
    sha256 cellar: :any_skip_relocation, monterey:       "d4943ceb1704084c1bc8a754f5b6b03b74c74321b65ae975cdbf52a35c0bc8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ef87667bf32b04c804a1df8fc24dd5205480443b0893211f33ddf3d4bee78de"
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
        DefaultGODEBUG panicnil=1
           CGO_ENABLED 1
                GOARCH #{goarch}
                  GOOS #{goos}
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end