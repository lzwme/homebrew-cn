class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https:about.gitea.com"
  url "https:dl.gitea.comgitea1.23.6gitea-src-1.23.6.tar.gz"
  sha256 "7704ebce0e31617d9dad985d3f3f4828855ad856383b9efc5a2f81befbed693c"
  license "MIT"
  head "https:github.comgo-giteagitea.git", branch: "main"

  livecheck do
    url "https:dl.gitea.comgiteaversion.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6d5a62f08e6a3b6da928adc38ce4075d71eeb8c3251b053e9c62de8b44417c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfeb3341e8ef323800d62101589b5e37f5d970846de063cb845441472dcfbe1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6af0ea2ca68b51c394a1545d50d882d862962552774618509b43f8a8e6c7d699"
    sha256 cellar: :any_skip_relocation, sonoma:        "c06fbc2a25acbc18adc80fce7fd5879ff9440d87a50bae1885dd5b50d73895e3"
    sha256 cellar: :any_skip_relocation, ventura:       "897b5527109572788475eb5875414cfce6ad40859f3d9876b9f144ebb9f8aff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35928b440437fc2e04cd7f47ee9ed5a4da796fe2db8406696361e6352c4f2a8"
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