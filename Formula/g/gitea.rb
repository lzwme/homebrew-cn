class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https:about.gitea.com"
  url "https:dl.gitea.comgitea1.24.1gitea-src-1.24.1.tar.gz"
  sha256 "c27cc4dde9744e8961f72a42b6a15ca127aa3dc6c153dea587fd420ac04d1493"
  license "MIT"
  head "https:github.comgo-giteagitea.git", branch: "main"

  livecheck do
    url "https:dl.gitea.comgiteaversion.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73db4e5c887380cba51e892275b547be7b0bb6d1307746a032a0fdc093e89bba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a363b3497f5c17f7d83d490f148dd9477e9835fbf73d05491a806ee50b07c76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e59d0d6e8c0ca822a3577db2f56bb0f93c53df1746b9b18e7edea66ef6435984"
    sha256 cellar: :any_skip_relocation, sonoma:        "04bf7c1225dcdc96cf3cbb71bc94b5215facd71ad9027cec0ecccf1e02746ff0"
    sha256 cellar: :any_skip_relocation, ventura:       "1f648a64a649278b48a99df5fb4f63cdba4dc5dc4506934ef53d368138d98387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062651b1adccc6f5c8253820f33d7e28ce5fb75f3cadd2175c08157820bd3ea5"
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
    run [opt_bin"gitea", "web", "--work-path", var"gitea"]
    keep_alive true
    log_path var"loggitea.log"
    error_log_path var"loggitea.log"
  end

  test do
    ENV["GITEA_WORK_DIR"] = testpath
    port = free_port

    pid = fork do
      exec bin"gitea", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s http:localhost:#{port}apisettingsapi")
    assert_match "Go to default page", output

    output = shell_output("curl -s http:localhost:#{port}")
    assert_match "Installation - Gitea: Git with a cup of tea", output

    assert_match version.to_s, shell_output("#{bin}gitea -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end