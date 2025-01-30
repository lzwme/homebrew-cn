class Questdb < Formula
  desc "Time Series Database"
  homepage "https:questdb.io"
  url "https:github.comquestdbquestdbreleasesdownload8.2.2questdb-8.2.2-no-jre-bin.tar.gz"
  sha256 "2f3dc06ce1b03ea4d5da06da71aa61301f585c8bae30d77cdac6f575747befb0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eecfb37dd9affa215bfad29529bbfb153640b008eaf5bd0e96c9f7690c579051"
  end

  depends_on "openjdk"

  def install
    rm_r("questdb.exe")
    libexec.install Dir["*"]
    (bin"questdb").write_env_script libexec"questdb.sh", Language::Java.overridable_java_home_env
    inreplace libexec"questdb.sh", "usrlocalvarquestdb", var"questdb"
  end

  def post_install
    # Make sure the varquestdb directory exists
    (var"questdb").mkpath
  end

  service do
    run [opt_bin"questdb", "start", "-d", var"questdb", "-n", "-f"]
    keep_alive successful_exit: false
    error_log_path var"logquestdb.log"
    log_path var"logquestdb.log"
    working_dir var"questdb"
  end

  test do
    # questdb.sh uses `ps | grep` to verify server is running, but output is truncated to COLUMNS
    # See https:github.comHomebrewhomebrew-corepull133887#issuecomment-1679907729
    ENV.delete "COLUMNS" if OS.linux?

    mkdir_p testpath"data"
    begin
      fork do
        exec bin"questdb", "start", "-d", testpath"data"
      end
      sleep 30
      output = shell_output("curl -Is localhost:9000index.html")
      sleep 8
      assert_match "questDB", output
    ensure
      system bin"questdb", "stop"
    end
  end
end