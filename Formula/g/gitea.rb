class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https:about.gitea.com"
  url "https:dl.gitea.comgitea1.23.3gitea-src-1.23.3.tar.gz"
  sha256 "e3c2993c06d3f717aa9000c877d090da18b51b1f708c569e85b7d67fa643bad3"
  license "MIT"
  head "https:github.comgo-giteagitea.git", branch: "main"

  livecheck do
    url "https:dl.gitea.comgiteaversion.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3d3c1a7b1ffb5a584c9721f49386f363ceb7bf2bf7591f171bbb9600a8ea7f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77e109495f4431868259261bab11888a037ef3e2521ca5ee2aa3463c0239ee99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31754ffebf73ebfb57c9178da5fc6eb4715ec0fdca2c1c5a31eccb5f85bb0d59"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc82437616c25101d402f11d405ac5ec36bc4de97413058fe1e26af73d729c62"
    sha256 cellar: :any_skip_relocation, ventura:       "52335824796389c473c7d692ad859880afc6f2d0a29b611aa2cf545ad55e3bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "240abbcfd1f741c07e0cb608eac5d4b52e007e34874c957e2ad2aca1d941dab3"
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