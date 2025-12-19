class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.25.3/gitea-src-1.25.3.tar.gz"
  sha256 "594f37000ac09016ed01f6dadb64f745ae3a16887cc0c97873cedd081f10ce34"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be433ecbb19092991807566c5db0b771abb7d53c5717053ca86c6b00e4e14e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd3e67c05e3b869a29566502cd56355b0f87eef59dd66166cade2cc1b13fad33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab754d51c1286e69308c7e165ae3f4226a17f37206ad673c35853100c87d67b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4113394445ddcb411c22b887ca409f374b023cc7016195c629178d7a62dcfa8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "203c2227638ffbbd238f1e241d34eac2084fba836856fa745214eef2a8a2c881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23772c4ee28e82c7cd2f864feeb84c0d463f51b7303cbedea64b4c28bbdd4fb5"
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