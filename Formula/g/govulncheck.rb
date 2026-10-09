class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  # git checkout needed for buildInfo support
  url "https://github.com/golang/vuln.git",
      tag:      "v1.8.0",
      revision: "709015412431dd2b5b28a53c06c70bc02d49074c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e51d4a608a38d3484106b77eb1369962af918b40f8f284876d64cd32d5b7281"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e51d4a608a38d3484106b77eb1369962af918b40f8f284876d64cd32d5b7281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e51d4a608a38d3484106b77eb1369962af918b40f8f284876d64cd32d5b7281"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f014f54ffc74d157abaa0ee90b75f3f782ee6b50c507d59d80329f5bb381d984"
    sha256 cellar: :any,                 x86_64_linux:      "e28391537fba9c168d702b72fc5360f5375597e9e2a4b31eca5de91e607ebb36"
  end

  depends_on "go" => [:build, :test]

  # `test do` block queries the Go vulnerability database
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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