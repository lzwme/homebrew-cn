class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-5.10.0.zip"
  sha256 "c51e2a8a3cfa44df0db71313416d26f5df54429331cdc510894c21234405c8c6"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7c3cdefc7957cf65de0745e0dcefcbb79d8dfbd2fa8ce38fc246ff97656004d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7c3cdefc7957cf65de0745e0dcefcbb79d8dfbd2fa8ce38fc246ff97656004d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7c3cdefc7957cf65de0745e0dcefcbb79d8dfbd2fa8ce38fc246ff97656004d"
    sha256 cellar: :any_skip_relocation, ventura:        "f7c3cdefc7957cf65de0745e0dcefcbb79d8dfbd2fa8ce38fc246ff97656004d"
    sha256 cellar: :any_skip_relocation, monterey:       "f7c3cdefc7957cf65de0745e0dcefcbb79d8dfbd2fa8ce38fc246ff97656004d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7c3cdefc7957cf65de0745e0dcefcbb79d8dfbd2fa8ce38fc246ff97656004d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d25d4cbd939274f802b5f6b13392a6cabc8b9b6c85122a8c5c1c2028d3f90b29"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"cypher-shell").write_env_script libexec/"bin/cypher-shell", Language::Java.overridable_java_home_env
  end

  test do
    # The connection will fail and print the name of the host
    assert_match "doesntexist", shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end