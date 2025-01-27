class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https:github.comburrowersgarble"
  url "https:github.comburrowersgarblearchiverefstagsv0.14.0.tar.gz"
  sha256 "9fb75bad82fc89afe08bbdb26c9bbbba8766a1663f8bb585318cf363fd3eedbf"
  license "BSD-3-Clause"
  head "https:github.comburrowersgarble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d1be3f91dabb549a77e2be50af5e12010f1a8995b90b77ef2a93d199bca7d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d1be3f91dabb549a77e2be50af5e12010f1a8995b90b77ef2a93d199bca7d7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d1be3f91dabb549a77e2be50af5e12010f1a8995b90b77ef2a93d199bca7d7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8efbcf212a953fbc184ce0b2ca15453583e0ab2c4c6b83998906d08e34ca83e"
    sha256 cellar: :any_skip_relocation, ventura:       "d8efbcf212a953fbc184ce0b2ca15453583e0ab2c4c6b83998906d08e34ca83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f5517d6c908e55967ef4b3ec508311fb8cc81c93202f979e4c359fe2add7276"
  end

  depends_on "go" => [:build, :test]
  depends_on "git"

  def install
    inreplace "internallinkerlinker.go", "\"git\"", "\"#{Formula["git"].opt_bin}git\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO
    system bin"garble", "-literals", "-tiny", "build", testpath"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}garble version")
  end
end