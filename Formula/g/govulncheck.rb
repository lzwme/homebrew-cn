class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://ghfast.top/https://github.com/golang/vuln/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "4fb7f0204b7e039f550d8938b714c5218d870694895585e0e19b2c0c4700e4c7"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa7f7be29e3e68c02ee2f4a50b2ca074640ba96d77079aad6c476d8834577752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa7f7be29e3e68c02ee2f4a50b2ca074640ba96d77079aad6c476d8834577752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa7f7be29e3e68c02ee2f4a50b2ca074640ba96d77079aad6c476d8834577752"
    sha256 cellar: :any_skip_relocation, sonoma:        "401cb80bbab286905c886033bf0a1fc77ad9496595fade192ec4109cbb1335d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2cee7216c73ac97cb1c8f982ee91ddf55d9677950879620854cf3c868883af3"
    sha256 cellar: :any,                 x86_64_linux:  "855e4eb51b5b027208ce8a1dfd0a20eb57c9aa2c3fbe0e34b4b4ac1e08f5ac90"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "./cmd/govulncheck"
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