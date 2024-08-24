class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https:cassandra-reaper.io"
  url "https:github.comthelastpicklecassandra-reaperreleasesdownload3.6.1cassandra-reaper-3.6.1-release.tar.gz"
  sha256 "8e5004692d031e2abe47c26c066d853fb1f841b23833edd66d58ff54bef82399"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d3600523c5e7a0f11954710872d7a2b5d1ae39240779ccf37e6e762f683e5feb"
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