class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.21.2-unix.tar.gz"
  sha256 "19fd2ddbedf9fab526cdec55d1d5cbc9ebda282984f8af9fb7216d9dbc7d0af6"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2d58d5f4da22e9a215c1cfc97e474e68903f2ba622a6bca709780fa399dd5dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2d58d5f4da22e9a215c1cfc97e474e68903f2ba622a6bca709780fa399dd5dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2d58d5f4da22e9a215c1cfc97e474e68903f2ba622a6bca709780fa399dd5dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a24716bfce36860ea21f3da3f5d2fd47d2fdf4f85ea53571769f3836e4501f17"
    sha256 cellar: :any_skip_relocation, ventura:        "a24716bfce36860ea21f3da3f5d2fd47d2fdf4f85ea53571769f3836e4501f17"
    sha256 cellar: :any_skip_relocation, monterey:       "a24716bfce36860ea21f3da3f5d2fd47d2fdf4f85ea53571769f3836e4501f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a866261cbce0b07890ad2571fd9ed041081c2221a343618c8b0c7eb304039363"
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