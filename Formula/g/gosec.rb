class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://ghfast.top/https://github.com/securego/gosec/archive/refs/tags/v2.24.6.tar.gz"
  sha256 "8e51ad7be142764bf57c23a0033fddbcffe8163e79aaa7d41fe2cd54ce7206a9"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f51a46f6fb62a153d5a37169079a271e8fdef96de984eba2476057316c4d895a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f51a46f6fb62a153d5a37169079a271e8fdef96de984eba2476057316c4d895a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f51a46f6fb62a153d5a37169079a271e8fdef96de984eba2476057316c4d895a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a386c63619daf337cc0b4e8c4387163dfca25d8ae9809bd6542c779473165c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abbd409742ed32ab3e4c60c4b8dac1bfd22f595aaa46bef3f1754cf0baae476a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b7947d9161d2494cbf5f85da89d6f735e1f4a380c1098a7053062ba2f139fb"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitTag= -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gosec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gosec --version")

    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    GO

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end