class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://ghfast.top/https://github.com/securego/gosec/archive/refs/tags/v2.22.7.tar.gz"
  sha256 "933d8a32b939c146f69a334e39e072a3a1423dc7a170ec98bdfe7e3c8061619f"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e370c4a59a74391613772868544fda648c30849724e1ead9e0fe3cb95325f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e370c4a59a74391613772868544fda648c30849724e1ead9e0fe3cb95325f9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e370c4a59a74391613772868544fda648c30849724e1ead9e0fe3cb95325f9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9fc395eeabcf8fb2ea8fd10990adc7853288f77a7e2120f3934d433115952ad"
    sha256 cellar: :any_skip_relocation, ventura:       "f9fc395eeabcf8fb2ea8fd10990adc7853288f77a7e2120f3934d433115952ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5346bc05b579c74f04dce03b1a7668fc392c8d0460076fceaf3eb3a847b1815f"
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