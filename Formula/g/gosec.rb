class Gosec < Formula
  desc "Golang security checker"
  homepage "https:securego.io"
  url "https:github.comsecuregogosecarchiverefstagsv2.22.1.tar.gz"
  sha256 "ac52b900616afd063d7c13624fb760aa282618ca7c2a30bfa3616b137678ed8e"
  license "Apache-2.0"
  head "https:github.comsecuregogosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39547df556beebd459dbb1515f9a485facdcf17cb51743e6264608ff45e74881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39547df556beebd459dbb1515f9a485facdcf17cb51743e6264608ff45e74881"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39547df556beebd459dbb1515f9a485facdcf17cb51743e6264608ff45e74881"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca281764cda7eeae23c8331e7cc869c3a1b070086e7ada1b5ef6554d6735b34b"
    sha256 cellar: :any_skip_relocation, ventura:       "ca281764cda7eeae23c8331e7cc869c3a1b070086e7ada1b5ef6554d6735b34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16400b90bdea85343536474bcdc34515d8c2420d0e5ada72e9e4a8ba82bd1006"
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