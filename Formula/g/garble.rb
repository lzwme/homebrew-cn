class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https:github.comburrowersgarble"
  url "https:github.comburrowersgarblearchiverefstagsv0.13.0.tar.gz"
  sha256 "22a1696ce880b34ca5ff949b6b5a42d4e370502e0b40b59eaa679eae13e45363"
  license "BSD-3-Clause"
  head "https:github.comburrowersgarble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "acce39931c080a560f3e718d6717dcb05e045e211ade8a1b2e8095194a1ab448"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acce39931c080a560f3e718d6717dcb05e045e211ade8a1b2e8095194a1ab448"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acce39931c080a560f3e718d6717dcb05e045e211ade8a1b2e8095194a1ab448"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acce39931c080a560f3e718d6717dcb05e045e211ade8a1b2e8095194a1ab448"
    sha256 cellar: :any_skip_relocation, sonoma:         "22a6ded5cae8b50a57daa03a7181bc0966220d456c45724fc31866b08f063837"
    sha256 cellar: :any_skip_relocation, ventura:        "22a6ded5cae8b50a57daa03a7181bc0966220d456c45724fc31866b08f063837"
    sha256 cellar: :any_skip_relocation, monterey:       "22a6ded5cae8b50a57daa03a7181bc0966220d456c45724fc31866b08f063837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "515e83bf8ff50fd75e0088951544e219cff5772a48c8bd9d321da7bc7722c5da"
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

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}garble version")
  end
end