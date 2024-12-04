class Gosec < Formula
  desc "Golang security checker"
  homepage "https:securego.io"
  url "https:github.comsecuregogosecarchiverefstagsv2.21.4.tar.gz"
  sha256 "fe3d78c52383164906d3cca5b22e693e22a146a4b89a8f60438fdaa833e32b3f"
  license "Apache-2.0"
  head "https:github.comsecuregogosec.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0193dd59288ec01a5cf4679b3a6ae4da8c4d02e39bd799d0cfb0e2492d634f6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0193dd59288ec01a5cf4679b3a6ae4da8c4d02e39bd799d0cfb0e2492d634f6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0193dd59288ec01a5cf4679b3a6ae4da8c4d02e39bd799d0cfb0e2492d634f6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "60cab52631b73a9eb2b9f74f1aeef0f5a66902009412d43b3395c4c041dc023a"
    sha256 cellar: :any_skip_relocation, ventura:       "60cab52631b73a9eb2b9f74f1aeef0f5a66902009412d43b3395c4c041dc023a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca434b1c6fb412c4f5da4b318380e148632417fd7e4f69ba18eed3f7a043c637"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitTag= -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgosec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gosec --version")

    (testpath"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    GO

    output = shell_output("#{bin}gosec ....", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end