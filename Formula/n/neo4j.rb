class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.23.0-unix.tar.gz"
  sha256 "ba71776c80ff5882524e6a535c942776249cffdcd0036baf9e1a1a257722285f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6a96c2cf085392c178fc5178bf4f34f64d771f85f7ecdc757efc4e2415837098"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a96c2cf085392c178fc5178bf4f34f64d771f85f7ecdc757efc4e2415837098"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a96c2cf085392c178fc5178bf4f34f64d771f85f7ecdc757efc4e2415837098"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a96c2cf085392c178fc5178bf4f34f64d771f85f7ecdc757efc4e2415837098"
    sha256 cellar: :any_skip_relocation, sonoma:         "acbcc86bd703dd71220ad921843c72df30f8a73b0291d157a7d3d139f27913cf"
    sha256 cellar: :any_skip_relocation, ventura:        "acbcc86bd703dd71220ad921843c72df30f8a73b0291d157a7d3d139f27913cf"
    sha256 cellar: :any_skip_relocation, monterey:       "acbcc86bd703dd71220ad921843c72df30f8a73b0291d157a7d3d139f27913cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a96c2cf085392c178fc5178bf4f34f64d771f85f7ecdc757efc4e2415837098"
  end

  depends_on "cypher-shell"
  depends_on "openjdk@21"

  def install
    env = {
      JAVA_HOME:  Formula["openjdk@21"].opt_prefix,
      NEO4J_HOME: libexec,
    }
    # Remove windows files
    rm(Dir["bin/*.bat"])

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Symlink binaries
    bin.install Dir["#{libexec}/bin/neo4j{,-shell,-import,-shared.sh,-admin}"]
    bin.env_script_all_files(libexec/"bin", env)

    # Adjust UDC props
    # Suppress the empty, focus-stealing java gui.
    (libexec/"conf/neo4j.conf").append_lines <<~EOS
      server.jvm.additional=-Djava.awt.headless=true-Dunsupported.dbms.udc.source=homebrew
      server.directories.data=#{var}/neo4j/data
      server.directories.logs=#{var}/log/neo4j
    EOS
  end

  def post_install
    (var/"log/neo4j").mkpath
    (var/"neo4j").mkpath
  end

  service do
    run [opt_bin/"neo4j", "console"]
    keep_alive false
    working_dir var
    log_path var/"log/neo4j.log"
    error_log_path var/"log/neo4j.log"
  end

  test do
    ENV["NEO4J_HOME"] = libexec
    ENV["NEO4J_LOG"] = testpath/"libexec/data/log/neo4j.log"
    ENV["NEO4J_PIDFILE"] = testpath/"libexec/data/neo4j-service.pid"
    mkpath testpath/"libexec/data/log"
    assert_match(/Neo4j .*is not running/i, shell_output("#{bin}/neo4j status 2>&1", 3))
  end
end