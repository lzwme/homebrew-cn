class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghfast.top/https://github.com/burrowers/garble/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "56ca8f1c354eb1043c18099726c7ab7b685751d5f020434561b1676308ea9754"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb2a4103781b16daa229b9ac779617ee798d9215be6b1712575dacadba1d29dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb2a4103781b16daa229b9ac779617ee798d9215be6b1712575dacadba1d29dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb2a4103781b16daa229b9ac779617ee798d9215be6b1712575dacadba1d29dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "335579e0142632841f58518894a5001dcf331bcddc40a6b45893916e68f82492"
    sha256 cellar: :any,                 x86_64_linux:      "8987975c798693bf7d018ab853085a726cb998e5255d6776c224f827ed92ff82"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO

    # `garble` breaks our git shim by clearing the environment.
    # Remove once git is no longer needed. See caveats:
    # https://github.com/burrowers/garble?tab=readme-ov-file#caveats
    ENV.remove "PATH", "#{HOMEBREW_SHIMS_PATH}/shared:"

    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end