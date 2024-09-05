class Gosec < Formula
  desc "Golang security checker"
  homepage "https:securego.io"
  url "https:github.comsecuregogosecarchiverefstagsv2.21.1.tar.gz"
  sha256 "9f5527a637299d452b5a04d22395551bf76fe4ca9e3d193c0c5ae5e8176c09bd"
  license "Apache-2.0"
  head "https:github.comsecuregogosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c7e34fe0a4c204016a9e5cf9753ef2e7512980f2c6bd2cbe535fd2a6d1aec5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c7e34fe0a4c204016a9e5cf9753ef2e7512980f2c6bd2cbe535fd2a6d1aec5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c7e34fe0a4c204016a9e5cf9753ef2e7512980f2c6bd2cbe535fd2a6d1aec5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d94ab6cead7f43f09f68e6f7d93ff2ada628bceef34d9f5e726e367b9530407"
    sha256 cellar: :any_skip_relocation, ventura:        "9d94ab6cead7f43f09f68e6f7d93ff2ada628bceef34d9f5e726e367b9530407"
    sha256 cellar: :any_skip_relocation, monterey:       "9d94ab6cead7f43f09f68e6f7d93ff2ada628bceef34d9f5e726e367b9530407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67091d5c1d9d483533db71b740f9d527c42df3da4de568ced3d01da2833ff87a"
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