class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.25.0/gitea-src-1.25.0.tar.gz"
  sha256 "6ce85e249ed6b0915aa1c5dbeb4ffe3da60ff4f27749088145938c692debee15"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48d4843b02a68a9de8154d05522dd9a4630bd03a82789e9df92a944828f8fbd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daf2df44aade2ab0127ff4c150b8101e08dbc0113c2bbd93baccf4aaa9fad1d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7485f5844b3328604e51c20a4b2bb7babcac2c0cd2d81838f97c0e51572ef75"
    sha256 cellar: :any_skip_relocation, sonoma:        "593a040d1bbc707d729822b6c3d96a661615a905423702b4fffe1283ce46a780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd8319d3ad278bd079122d4f5e753ad45bd234dc877b087e8df030fdf9e3dfc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ecd4783963a1349fbec44c9b024eb68a7f4bf09b28000b0d0d7558a02f4032d"
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