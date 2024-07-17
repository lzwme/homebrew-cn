class Questdb < Formula
  desc "Time Series Database"
  homepage "https:questdb.io"
  url "https:github.comquestdbquestdbreleasesdownload8.0.3questdb-8.0.3-no-jre-bin.tar.gz"
  sha256 "a17f2a987a7a71fa0e755b3f5ef81daa14399ab1f912208aaf6f0ec6e9393424"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "685647508ab9f132bee88801d334a566494c53af0bd10338d51fec3c47f05c94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "685647508ab9f132bee88801d334a566494c53af0bd10338d51fec3c47f05c94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "685647508ab9f132bee88801d334a566494c53af0bd10338d51fec3c47f05c94"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe8204660cc4191ecdbe87f0d0b90ae6394fc059766661a0fb6f8d7f2e275ec8"
    sha256 cellar: :any_skip_relocation, ventura:        "fe8204660cc4191ecdbe87f0d0b90ae6394fc059766661a0fb6f8d7f2e275ec8"
    sha256 cellar: :any_skip_relocation, monterey:       "685647508ab9f132bee88801d334a566494c53af0bd10338d51fec3c47f05c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4b5514cba9fd8ebe275cd3daedb5d6c26987a52a851cbc8094ce4f2874687ef"
  end

  depends_on "openjdk"

  def install
    rm_rf "questdb.exe"
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
      sleep 4
      assert_match "questDB", output
    ensure
      system bin"questdb", "stop"
    end
  end
end