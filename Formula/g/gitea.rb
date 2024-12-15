class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https:about.gitea.com"
  url "https:dl.gitea.comgitea1.22.6gitea-src-1.22.6.tar.gz"
  sha256 "251a3ee97e11f288764f9e15d0163116a04f2811b9d0d3c32f46a04f90f0756e"
  license "MIT"
  head "https:github.comgo-giteagitea.git", branch: "main"

  livecheck do
    url "https:dl.gitea.comgiteaversion.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee51a66497d65c8ec53ba33c188569d6c0f1017ec90805c19d0379089bc45cc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bfa1b189bb5e71953f7cdb54a83c2f25612ca5b1586df79267de77321095a9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7c03923aeca85aee837a0a2135fed924c2868b5d93cb502ea52289119e82926"
    sha256 cellar: :any_skip_relocation, sonoma:        "00a298aa8450e0aa216be345825726cf34e5c2374dcd7c940829fcc52d69d74c"
    sha256 cellar: :any_skip_relocation, ventura:       "897e025fc8144ddd43aae32efa2eb0db627977f49df9f0735213af352e1888e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19745ec3e0030df2be49248edde01b4ce595d248b8f9618bedb8c0c124f1e6d2"
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