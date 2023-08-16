class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.11.0-unix.tar.gz"
  sha256 "3a206271d01ff337ab64e99a9ea90b17733416ec17c093b5be7bfb9342b0dacd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "906af5e8f90d00afa2c495b01ac1049adf1e41f3126bf6ac72e29c44822cc47e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "906af5e8f90d00afa2c495b01ac1049adf1e41f3126bf6ac72e29c44822cc47e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "906af5e8f90d00afa2c495b01ac1049adf1e41f3126bf6ac72e29c44822cc47e"
    sha256 cellar: :any_skip_relocation, ventura:        "bec1e6ec2b90febeede325bdb1f69edbd7eeb561afb56e5e6000fa75563eca1f"
    sha256 cellar: :any_skip_relocation, monterey:       "bec1e6ec2b90febeede325bdb1f69edbd7eeb561afb56e5e6000fa75563eca1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bec1e6ec2b90febeede325bdb1f69edbd7eeb561afb56e5e6000fa75563eca1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "906af5e8f90d00afa2c495b01ac1049adf1e41f3126bf6ac72e29c44822cc47e"
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