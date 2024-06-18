class Questdb < Formula
  desc "Time Series Database"
  homepage "https:questdb.io"
  url "https:github.comquestdbquestdbreleasesdownload8.0.1questdb-8.0.1-no-jre-bin.tar.gz"
  sha256 "4ba8ba5cbc45a48c58025c42bbe300ce730b9015afa7c415c6079dfab602593d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, sonoma:         "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, ventura:        "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, monterey:       "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c02e9e85196edc9ddc3c13495d4f7a9a9f77adab8a8513760a0b8ff7b093fdf"
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