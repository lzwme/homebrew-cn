class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-5.21.0.zip"
  sha256 "98120a168bf67c6040429d0abab44371c588577680508edcd741a70c2ceca8a6"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ea8ebd096009958e00f8fb414415269f99c485f1707ca084a1ac4291ef18c37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ea8ebd096009958e00f8fb414415269f99c485f1707ca084a1ac4291ef18c37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ea8ebd096009958e00f8fb414415269f99c485f1707ca084a1ac4291ef18c37"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ea8ebd096009958e00f8fb414415269f99c485f1707ca084a1ac4291ef18c37"
    sha256 cellar: :any_skip_relocation, ventura:        "6ea8ebd096009958e00f8fb414415269f99c485f1707ca084a1ac4291ef18c37"
    sha256 cellar: :any_skip_relocation, monterey:       "6ea8ebd096009958e00f8fb414415269f99c485f1707ca084a1ac4291ef18c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00df5fc90076b5d584167114f8d9ea33cd59568cb8584a321707900ba3367ff"
  end

  depends_on "openjdk"

  conflicts_with "neo4j", because: "both install `cypher-shell` binaries"

  def install
    libexec.install Dir["*"]
    (bin/"cypher-shell").write_env_script libexec/"bin/cypher-shell", Language::Java.overridable_java_home_env
  end

  test do
    # The connection will fail and print the name of the host
    assert_match "doesntexist", shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end