class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.24.3/gitea-src-1.24.3.tar.gz"
  sha256 "6e5b0130c46164b6f1e9f8450a76dc0ee2158cec180c423bcfcf323ec63070be"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1bae983164ee88611657f39d7eeae533fe15ba82a60c2e571c2ba04f81a8848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8bbaf0885d96ee22c855db37dc8e18a5ddf1c98f046c7b81d094b9ad1a8bf5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53f5c3db1a032ae0f0a8856fae25b099504f2fee5e9ef84798a45635d12dfe24"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc556cf429b9ecf0ba4c7e7ea0a8526468ea89ccb424fd86cc5464b1c00ddbee"
    sha256 cellar: :any_skip_relocation, ventura:       "89fd9fad054c609d8575e72c7c15e701779f83d742ca33b57b0123d29b28fbe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "799bfa16f567eee0e13e88062c7a43d81dde279f9520c1722ed2c67322df5a30"
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
    run [opt_bin/"gitea", "web", "--work-path", var/"gitea"]
    keep_alive true
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
    sleep 10 if OS.mac? && Hardware::CPU.intel?

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