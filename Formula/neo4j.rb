class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.10.0-unix.tar.gz"
  sha256 "2bbf7257481874b0f4b025d0344f81fe972bba1f20fd18e3eb8840ff04ad1b33"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7405514fee5b68039bc3d6c42c62134b20ae76cc27ecd9c053f33f1ea9d7a32c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7405514fee5b68039bc3d6c42c62134b20ae76cc27ecd9c053f33f1ea9d7a32c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7405514fee5b68039bc3d6c42c62134b20ae76cc27ecd9c053f33f1ea9d7a32c"
    sha256 cellar: :any_skip_relocation, ventura:        "2c911a8da4963864cdfc751f6130b2bb871291b55d6e3d50645ae3f7db7d72ac"
    sha256 cellar: :any_skip_relocation, monterey:       "2c911a8da4963864cdfc751f6130b2bb871291b55d6e3d50645ae3f7db7d72ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c911a8da4963864cdfc751f6130b2bb871291b55d6e3d50645ae3f7db7d72ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec26679f0b9a6f1fdd51ee167950c14e40f861f89b4091c04b44df2106981fe3"
  end

  depends_on "openjdk"

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