class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  # git checkout needed for buildInfo support
  url "https://github.com/golang/vuln.git",
      tag:      "v1.7.0",
      revision: "617f44b718537dccdea1915395650e0529e3b72e"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "323c0bed415a875c630b84a3f98a66c9584b4333339b8a72a18bb23a8e4a50d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "323c0bed415a875c630b84a3f98a66c9584b4333339b8a72a18bb23a8e4a50d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "323c0bed415a875c630b84a3f98a66c9584b4333339b8a72a18bb23a8e4a50d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7adec523a851b911f6132e48eec81e51ff3c9012dcae721f4a48cd06418d9527"
    sha256 cellar: :any,                 x86_64_linux:  "c2ce8a517a7869b781ab275b61f96771caf03ea1ded584675e02ba5b32cbb937"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "./cmd/govulncheck"
  end

  test do
    assert_match "Scanner: govulncheck@v#{version}", shell_output("#{bin}/govulncheck --version")
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~GO
        package main

        func main() {}
      GO

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end