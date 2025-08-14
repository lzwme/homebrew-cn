class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.24.5/gitea-src-1.24.5.tar.gz"
  sha256 "835118a9b92ee8854a7b3113d3a09670a36ea8882bb9c779303f4812c4687aeb"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "034cabf32b5d46459f359d018ec609b2aa23f787461df2cfbf9962c4aa86e985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cef3cba736d217636a573fb0841ae5b95158becdc029533f8d23dc82d6c23f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68d5b2fcd4f6a4d6b370407dd6e5c5a6c8a61a77f14b925b780684a2b68854f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae9f90adf600af204d511ef2bd9afe65197e0aefa0c480f981d587520af16d00"
    sha256 cellar: :any_skip_relocation, ventura:       "856f575592b242cd38d564e5c6e2a73c3afb647d785e5d8e40cfb9704a649b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a959d8d1bd8b438e3dd1b877b6dadb6c44cde6855bab5c915ec8dd53f73558d3"
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