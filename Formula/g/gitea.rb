class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https:about.gitea.com"
  url "https:dl.gitea.comgitea1.24.0gitea-src-1.24.0.tar.gz"
  sha256 "1c6bf91f6c7706d300a02f8cbe30e5edfd5e341f3deff365d611dc0d97f54fd2"
  license "MIT"
  head "https:github.comgo-giteagitea.git", branch: "main"

  livecheck do
    url "https:dl.gitea.comgiteaversion.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45a60ad98b94adcf71ef8cca1d6ea4b9d9b15900f6ed4a27cc93e0509f472f29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "405b556fa8afa05ba327cc010c91d56a8ce5ccb6317415b9b16cf030f2a62ed0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c6fba103d82985e3b2ab5733f0b6bc9683c855ca84e95a2e6430183c88aa076"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea83a8da4e837ec85cab91a89fd869516dc71ba81242ba83665434ffd0d8f9ca"
    sha256 cellar: :any_skip_relocation, ventura:       "d8fdeb1924d1d712db2facae99e327f1bff6d21f458b64f366d7102858c9271a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce8003c392ec03e08127f84cfe2b4e83de60b1aa5fbd36b8b84efa656ab1a22c"
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