class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.21.0-unix.tar.gz"
  sha256 "3451a852a986f1502b42ac74a7ca83520bdbb519d86e4d4c60f490e425057b18"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4d67eeaaf44a2bc2657ec635f618286e15a7989b894a1e499bfc6f20dc09ae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4d67eeaaf44a2bc2657ec635f618286e15a7989b894a1e499bfc6f20dc09ae3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d67eeaaf44a2bc2657ec635f618286e15a7989b894a1e499bfc6f20dc09ae3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a365dddd1bea0b9bc89379637b056f53d3d36ac01247309dc593473a16d6cd70"
    sha256 cellar: :any_skip_relocation, ventura:        "a365dddd1bea0b9bc89379637b056f53d3d36ac01247309dc593473a16d6cd70"
    sha256 cellar: :any_skip_relocation, monterey:       "a365dddd1bea0b9bc89379637b056f53d3d36ac01247309dc593473a16d6cd70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b07e880091c0cbc86503d29f54f41ad6feaee07181ac6de7e3ad27da6ba648a"
  end

  depends_on "openjdk"

  conflicts_with "cypher-shell", because: "both install `cypher-shell` binaries"

  def install
    env = {
      JAVA_HOME:  Formula["openjdk"].opt_prefix,
      NEO4J_HOME: libexec,
    }
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Symlink binaries
    bin.install Dir["#{libexec}/bin/neo4j{,-shell,-import,-shared.sh,-admin}", "#{libexec}/bin/cypher-shell"]
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