class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.21.1/gitea-src-1.21.1.tar.gz"
  sha256 "e5610750c42c40d82b8254bec49e08587525d1ae912cb3f2c7497e10227847d8"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f157641a4376b9ce3938bb9326c7f563686c500a9552a349fce03b9ff0d2155"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d960915bb603da7c4aa5ef51b190144abf16ff84e96a5ab0325b48c79524e2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0822d3cae7707b022621aa3a2bc77e7516d4ac070466a4ab039a414d21664055"
    sha256 cellar: :any_skip_relocation, sonoma:         "417953300c34bf91e99ad7bbb98c391f969c249264a7e24a60d4791869a2be4b"
    sha256 cellar: :any_skip_relocation, ventura:        "92a8120de4f67a2be873f9da295cc2d2cc9655c578b7b83d8d14a0ad8a85410a"
    sha256 cellar: :any_skip_relocation, monterey:       "df5ffad445ead3ad4a9ff217876918f788058b3072039e21f6b31d8e7875893c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f9bf13e7a205b682cc53f3cfa099e1cab819560982262186f1253187948a915"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea"
  end

  service do
    run [opt_bin/"gitea", "web"]
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/gitea.log"
    error_log_path var/"log/gitea.log"
  end

  test do
    ENV["GITEA_WORK_DIR"] = testpath
    port = free_port

    pid = fork do
      exec bin/"gitea", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 5

    output = shell_output("curl -s http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Gitea: Git with a cup of tea", output

    assert_match version.to_s, shell_output("#{bin}/gitea -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end