class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.6.0-unix.tar.gz"
  sha256 "16cc236a08fd99acea9b08dc9b19c016dc693bb97fa4f4ca81c2c90cf9452292"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b85feb3074e11fa70563db9e7af9913f3efc2b1e863b4fa8f6959c0971a7fbb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b85feb3074e11fa70563db9e7af9913f3efc2b1e863b4fa8f6959c0971a7fbb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b85feb3074e11fa70563db9e7af9913f3efc2b1e863b4fa8f6959c0971a7fbb4"
    sha256 cellar: :any_skip_relocation, ventura:        "b87fd1c5519d5ea12d2205912f663759ebf6d47994e3e48dd5cda874b11ef9cb"
    sha256 cellar: :any_skip_relocation, monterey:       "b87fd1c5519d5ea12d2205912f663759ebf6d47994e3e48dd5cda874b11ef9cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b87fd1c5519d5ea12d2205912f663759ebf6d47994e3e48dd5cda874b11ef9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b85feb3074e11fa70563db9e7af9913f3efc2b1e863b4fa8f6959c0971a7fbb4"
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
      wrapper.java.additional=-Djava.awt.headless=true
      wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew
      dbms.directories.data=#{var}/neo4j/data
      dbms.directories.logs=#{var}/log/neo4j
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