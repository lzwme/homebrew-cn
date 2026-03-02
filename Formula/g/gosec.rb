class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://ghfast.top/https://github.com/securego/gosec/archive/refs/tags/v2.24.7.tar.gz"
  sha256 "0d5509b17bb89ca1fa8f135ff88e498400a81bbb4c6fad19cb6aa34654249db8"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d48a4bbe0278928d98c21533a518bc9198dcbe0421f032a945e4604f00393f13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d48a4bbe0278928d98c21533a518bc9198dcbe0421f032a945e4604f00393f13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d48a4bbe0278928d98c21533a518bc9198dcbe0421f032a945e4604f00393f13"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ec8031f5d1cb5851ae00799922539126fdb9c0e6fab4e1de360da4cf4190260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfd342de31b57317ec57938db8daa3730910a5935bd3931cfbb149a40c7d20b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cc08fad2d16a7e64f60cb1a637924e54f3e8aa5eae7af9b3f7822b1e24d468b"
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