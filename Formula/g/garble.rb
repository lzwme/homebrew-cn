class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https:github.comburrowersgarble"
  url "https:github.comburrowersgarblearchiverefstagsv0.13.0.tar.gz"
  sha256 "22a1696ce880b34ca5ff949b6b5a42d4e370502e0b40b59eaa679eae13e45363"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comburrowersgarble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf422ccd3db2ebdc79667822a8ab1bb7bf71089a806ec9c55f314818d1c4258b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf422ccd3db2ebdc79667822a8ab1bb7bf71089a806ec9c55f314818d1c4258b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf422ccd3db2ebdc79667822a8ab1bb7bf71089a806ec9c55f314818d1c4258b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f5007592a1c41e28dca0eaa6bfd57d5f5de2dcbf4c9df766548b92144f5383a"
    sha256 cellar: :any_skip_relocation, ventura:       "1f5007592a1c41e28dca0eaa6bfd57d5f5de2dcbf4c9df766548b92144f5383a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5737f8c15863b2575cf80726e2857f1c9e6439804472f37b1d2d770924ccd045"
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