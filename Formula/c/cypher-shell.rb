class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-2026.07.0.zip"
  sha256 "3dba0b653090febeef8ed0cc93ce641fa827f0c4aaba44c96d415f218570e801"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0b978d69233c8f72b6ee5ebf941e0b5bd71a1995e5e7afaf4aaf1b94da2461f"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]
    (bin/"cypher-shell").write_env_script libexec/"bin/cypher-shell", Language::Java.overridable_java_home_env("21")
  end

  test do
    refute_match "unsupported version of the Java runtime", shell_output("#{bin}/cypher-shell -h 2>&1", 1)
    # The connection will fail and print the name of the host
    assert_match "doesntexist", shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end