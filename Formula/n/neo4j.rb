class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-5.13.0-unix.tar.gz"
  sha256 "c5b1834ae4493af9c623c7d4d68783de1f87d73adea34cd973d9daa3c2ea056c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afa346a780a986f2ec153e9a4a7fabb1d1c4401b66cc53fa9af18ede134e5b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afa346a780a986f2ec153e9a4a7fabb1d1c4401b66cc53fa9af18ede134e5b99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afa346a780a986f2ec153e9a4a7fabb1d1c4401b66cc53fa9af18ede134e5b99"
    sha256 cellar: :any_skip_relocation, sonoma:         "912e0971e00f72fddb881603a2a9dbc6077ac93617fbdfc1ed6fbf849bccf63c"
    sha256 cellar: :any_skip_relocation, ventura:        "912e0971e00f72fddb881603a2a9dbc6077ac93617fbdfc1ed6fbf849bccf63c"
    sha256 cellar: :any_skip_relocation, monterey:       "912e0971e00f72fddb881603a2a9dbc6077ac93617fbdfc1ed6fbf849bccf63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa346a780a986f2ec153e9a4a7fabb1d1c4401b66cc53fa9af18ede134e5b99"
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