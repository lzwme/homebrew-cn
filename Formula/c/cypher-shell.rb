class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-5.21.0.zip"
  sha256 "98120a168bf67c6040429d0abab44371c588577680508edcd741a70c2ceca8a6"
  license "GPL-3.0-only"
  revision 1
  version_scheme 1

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b15234e48cda90b4016156b29be6a1358771a97b21c38882d23b3baf1301030"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b15234e48cda90b4016156b29be6a1358771a97b21c38882d23b3baf1301030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b15234e48cda90b4016156b29be6a1358771a97b21c38882d23b3baf1301030"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b15234e48cda90b4016156b29be6a1358771a97b21c38882d23b3baf1301030"
    sha256 cellar: :any_skip_relocation, ventura:        "4ea149e155a93b4cb5b4da0715bf8962565155cabdf66c008e7e43ee437b7256"
    sha256 cellar: :any_skip_relocation, monterey:       "2b15234e48cda90b4016156b29be6a1358771a97b21c38882d23b3baf1301030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03ea1f073944ac41767c4d2de93f0c3387312693b542d3efe628770012216929"
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