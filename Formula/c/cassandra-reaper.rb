class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https:cassandra-reaper.io"
  url "https:github.comthelastpicklecassandra-reaperreleasesdownload3.6.0cassandra-reaper-3.6.0-release.tar.gz"
  sha256 "128b0ae381faebb4043e2c698477e7d5f399159c0eb2d991a32bfc1655cce839"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "519383b34bdad5458d04f9648d9a4af48b23f57f5936652c51ee9344f82896e5"
  end

  depends_on "openjdk@11"

  def install
    inreplace Dir["resource*.yaml"], " varlog", " #{var}log"
    inreplace "bincassandra-reaper", "usrlocalshare", share
    inreplace "bincassandra-reaper", "usrlocaletc", etc

    libexec.install "bincassandra-reaper"
    prefix.install "bin"
    etc.install "resource" => "cassandra-reaper"
    share.install "servertarget" => "cassandra-reaper"

    (bin"cassandra-reaper").write_env_script libexec"cassandra-reaper",
      Language::Java.overridable_java_home_env("11")
  end

  service do
    run opt_bin"cassandra-reaper"
    keep_alive true
    error_log_path var"logcassandra-reaperservice.err"
    log_path var"logcassandra-reaperservice.log"
  end

  test do
    cp etc"cassandra-reapercassandra-reaper.yaml", testpath
    port = free_port
    inreplace "cassandra-reaper.yaml" do |s|
      s.gsub! "port: 8080", "port: #{port}"
      s.gsub! "port: 8081", "port: #{free_port}"
      s.gsub! "storageType: memory", "storageType: memory\npersistenceStoragePath: #{testpath}persistence"
    end

    fork do
      exec bin"cassandra-reaper", testpath"cassandra-reaper.yaml"
    end
    sleep 40
    assert_match "200 OK", shell_output("curl -Im3 -o- http:localhost:#{port}webuilogin.html")
  end
end