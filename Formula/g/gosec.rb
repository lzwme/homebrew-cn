class Gosec < Formula
  desc "Golang security checker"
  homepage "https:securego.io"
  url "https:github.comsecuregogosecarchiverefstagsv2.21.3.tar.gz"
  sha256 "a055288d34dde54efcf6d3bdc1492d8384d661bf934b345d6db9cd8fc376472d"
  license "Apache-2.0"
  head "https:github.comsecuregogosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6149e9fa5db0b21d3620217c0a350ebc1579569e1f474eeb4a37bf652da0bdd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6149e9fa5db0b21d3620217c0a350ebc1579569e1f474eeb4a37bf652da0bdd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6149e9fa5db0b21d3620217c0a350ebc1579569e1f474eeb4a37bf652da0bdd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "12584b86db4e00885a8a3b88a34bb18e37b3828d5efa93784165fd750b9c0c6d"
    sha256 cellar: :any_skip_relocation, ventura:       "12584b86db4e00885a8a3b88a34bb18e37b3828d5efa93784165fd750b9c0c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16c5dd2be89f15e85064e0a20e108f4a76fd6adfaa8b950c694fa956b901fe80"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), ".cmdgosec"
  end

  test do
    (testpath"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    EOS

    output = shell_output("#{bin}gosec ....", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end