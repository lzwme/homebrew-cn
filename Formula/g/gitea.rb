class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https:about.gitea.com"
  url "https:dl.gitea.comgitea1.22.5gitea-src-1.22.5.tar.gz"
  sha256 "a3dd4ee93bb968099b1d723a2a5cb3d802a4be6c0407e92af3a021bf278e1a77"
  license "MIT"
  head "https:github.comgo-giteagitea.git", branch: "main"

  livecheck do
    url "https:dl.gitea.comgiteaversion.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a808565014652e6b57730102438351f518cd52b59a6b5ccf9a5be58372b21285"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3bda24912cda591d73e99fad8c9d8755862e79f2e112b73e22ba84d6cf441fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7fd56ef96306824c05021a286ab3a9226afd6e125c6a2b1a9e993d7e1f649d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad1e3f51b419c4147492bd8cde88255afc61c15aeb2ee591fceb0cd151f3cf6a"
    sha256 cellar: :any_skip_relocation, ventura:       "ac0fb29c1bd2ec83f70bd5db2fc0583cbc56ff7b63e136777a039e0226e63a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48e8b98e648327af9ed3482fba69559ff850aa6d991365a7cedf95496677bf2c"
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