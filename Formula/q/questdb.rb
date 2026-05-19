class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://ghfast.top/https://github.com/questdb/questdb/releases/download/9.4.0/questdb-9.4.0-no-jre-bin.tar.gz"
  sha256 "96a5b77c60c07498190cb2deef4dc79c6ae2db518ae4ff0bf2023fd8f4ce34cc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "939d88ab62b9f7ba6a0327733261865489ced1d8eaed7f0121b7b4a8aaa2c39d"
  end

  depends_on "openjdk"

  def install
    rm_r("questdb.exe")
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env
    inreplace libexec/"questdb.sh", "/usr/local/var/questdb", var/"questdb"

    # Make sure the var/questdb directory exists
    (var/"questdb").mkpath
  end

  service do
    run [opt_bin/"questdb", "start", "-d", var/"questdb", "-n", "-f"]
    keep_alive successful_exit: false
    error_log_path var/"log/questdb.log"
    log_path var/"log/questdb.log"
    working_dir var/"questdb"
  end

  test do
    # questdb.sh uses `ps | grep` to verify server is running, but output is truncated to COLUMNS
    # See https://github.com/Homebrew/homebrew-core/pull/133887#issuecomment-1679907729
    ENV.delete "COLUMNS" if OS.linux?

    mkdir_p testpath/"data"
    begin
      spawn bin/"questdb", "start", "-d", testpath/"data"
      output = shell_output("curl --head --silent --retry 5 --retry-connrefused localhost:9000/index.html")
      assert_match "questDB", output
    ensure
      system bin/"questdb", "stop"
    end
  end
end