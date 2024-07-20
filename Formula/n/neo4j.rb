class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.21.2-unix.tar.gz"
  sha256 "19fd2ddbedf9fab526cdec55d1d5cbc9ebda282984f8af9fb7216d9dbc7d0af6"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "892ef2ef19e5d2b0b78ba8e4141d47be2d08276c120c6285b79545ebb372e3b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "892ef2ef19e5d2b0b78ba8e4141d47be2d08276c120c6285b79545ebb372e3b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "892ef2ef19e5d2b0b78ba8e4141d47be2d08276c120c6285b79545ebb372e3b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dd5d271c9278a0c351b260bcad234018efa21fdf64b3df6ce4e4c5b19d28024"
    sha256 cellar: :any_skip_relocation, ventura:        "999887c4720d654942bca4b5a0f9d757a411545cf73ec70a30471346fc6f67b5"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd5d271c9278a0c351b260bcad234018efa21fdf64b3df6ce4e4c5b19d28024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3589d3a4106f28c1f4fe2ac356af46b874b4bae148420c5253d0aa4c375b8dc"
  end

  depends_on "cypher-shell"
  depends_on "openjdk@21"

  def install
    env = {
      JAVA_HOME:  Formula["openjdk@21"].opt_prefix,
      NEO4J_HOME: libexec,
    }
    # Remove windows files
    rm_f Dir["bin/*.bat"]

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