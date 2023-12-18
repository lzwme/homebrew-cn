class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https:cassandra-reaper.io"
  url "https:github.comthelastpicklecassandra-reaperreleasesdownload3.4.0cassandra-reaper-3.4.0-release.tar.gz"
  sha256 "3a1627baba2efa1691be1d8b2c1f525bc0ec50829431f04ac6ae3ce8d90e2c1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dcf70ac9080f1186c34dddab083184220386b0ebcf6be62f4b582e1ff16d76c0"
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
    end
    fork do
      exec "#{bin}cassandra-reaper", "#{testpath}cassandra-reaper.yaml"
    end
    sleep 30
    assert_match "200 OK", shell_output("curl -Im3 -o- http:localhost:#{port}webuilogin.html")
  end
end