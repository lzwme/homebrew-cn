class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://ghfast.top/https://github.com/golang/vuln/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "c2628a3fe43c2a0e75f3962ba7b72e8c1e35da59365db6ed63ed2870c549d466"
  license "BSD-3-Clause"
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baab13725b2d75c815e229f55ea3c9dea15a126346e43cee5788a5cd3148d684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baab13725b2d75c815e229f55ea3c9dea15a126346e43cee5788a5cd3148d684"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baab13725b2d75c815e229f55ea3c9dea15a126346e43cee5788a5cd3148d684"
    sha256 cellar: :any_skip_relocation, sonoma:        "268bf6709e8eb51cac643ea127dabae6a38ab4085c44fcbd585e89fca054f20d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5db5187b8c143676271dde1d13fcc7e0738aebd269fe0552772483e5a441efd"
    sha256 cellar: :any,                 x86_64_linux:  "3ea7eef5c72e3486c1eb203dec352f3e19962680fc8bfb3e162ad7c35c0970d8"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/govulncheck"
  end

  test do
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