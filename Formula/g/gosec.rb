class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://ghfast.top/https://github.com/securego/gosec/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "0d89a09e61c3da900bea24f2864c3995470910bfaed76f5eeca5f519db3619e8"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ce64d7b72b3b3173ba12da9427fff2f4a6d1d1d8fad63f5fd957a907f612021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ce64d7b72b3b3173ba12da9427fff2f4a6d1d1d8fad63f5fd957a907f612021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ce64d7b72b3b3173ba12da9427fff2f4a6d1d1d8fad63f5fd957a907f612021"
    sha256 cellar: :any_skip_relocation, sonoma:        "94c252d308a32471e412735226c90493024f4f40efa3943bd9e7d9b28dcca405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8576cd811005a4412920b46b66aa26a11e2d4b682be66ab8247ef6ef27e0295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c328d441739551304f93cb55d93980d278a1385a741bc5c0022a4abcfc5904ab"
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