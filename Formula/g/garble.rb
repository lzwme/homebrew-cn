class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https:github.comburrowersgarble"
  url "https:github.comburrowersgarblearchiverefstagsv0.12.1.tar.gz"
  sha256 "98ade316176d434f298bdb36e4c421e3c4c33668cfd2922d358f7f0403566500"
  license "BSD-3-Clause"
  revision 5
  head "https:github.comburrowersgarble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08c175b6d19de066ad8c6506ad8cee994f33ac0663f55af48faf6c008dd843b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f91de02c1b6fbfbb53eb33ff807adcd556a84a195ce51c01d1a3d731de05f368"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "251cd74bf20979d359c19ad293ee5693473c2a2ce482c602062438d37095771e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d520e1bee23dc82891613c9ccf676159d1bf436375a0555331c87d9e59138fec"
    sha256 cellar: :any_skip_relocation, ventura:        "d6afd111bea25924cf97fee5c6353b198bab43f7dc4a8471b987a84aba265bd5"
    sha256 cellar: :any_skip_relocation, monterey:       "766d5045d9e5e94088a8f061c699e14c7764dd27f423f225d7ea2948e12ba6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ff2b90bd83bb1b59c14a02a2da99bc7a8a3e85d6677e52e44c67e366602eb9"
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