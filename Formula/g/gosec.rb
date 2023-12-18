class Gosec < Formula
  desc "Golang security checker"
  homepage "https:securego.io"
  url "https:github.comsecuregogosecarchiverefstagsv2.18.2.tar.gz"
  sha256 "38989bc03a13f3452ca3ca7f8bfd5d265ddc798217dcf4919a0d6f8500d0c392"
  license "Apache-2.0"
  head "https:github.comsecuregogosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bdd66283ae0e956505e70d8ac8b0294c879746fdd1437a0e2d89487e1637e32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8f0bf84b72e741ce31e35b5bd56c5ae4dc7d8853a0b3cf862387daba8cc16fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e6fb1a60b06e9026ab031d0f9e93fc5d070991eb0282d267d1f6b4235344b60"
    sha256 cellar: :any_skip_relocation, sonoma:         "90ffeef2ef60e162da437e595f80ed2d1e60eaddde0094e46f9417c7f5a97189"
    sha256 cellar: :any_skip_relocation, ventura:        "9f5e2e339e222f717fb760800cd53c6031e9a1bacc79b1509bed09ba7258a94f"
    sha256 cellar: :any_skip_relocation, monterey:       "9e38902aa35ed3048763d9190736e572ce6b0bd0ac6a43ab20084f8368b59399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "988b25070698e2157596051970a4877f5d4dd045dc63a72b0fd459f52e0c3a76"
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