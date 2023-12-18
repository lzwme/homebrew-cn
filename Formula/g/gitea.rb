class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https:about.gitea.com"
  url "https:dl.gitea.comgitea1.21.2gitea-src-1.21.2.tar.gz"
  sha256 "fb31b8b722634b0a1c2035703a3e1187017b87fe96042386ffa8f80750035dab"
  license "MIT"
  head "https:github.comgo-giteagitea.git", branch: "main"

  livecheck do
    url "https:dl.gitea.comgiteaversion.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65898ef2a968fac47091f0a38e2516f0217115a50133c76bc55da379e11eaf06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39daf8086becc04cf8711e3a60a98205fd18830009b4e2c4dcf5a162a26a6bc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bce2579eaebafe9be7c5304dec1a1f1ec104ddaceed2594728b4ca9860016a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7708ac93d5731b2a366e67db39d35af99974fd7ab11180f32307e495ac240aa0"
    sha256 cellar: :any_skip_relocation, ventura:        "badbe355c93cc0f5224ccc7268c2b00534c937888e2a39061ee01580814d6f19"
    sha256 cellar: :any_skip_relocation, monterey:       "ee064196e13e74efb23da48aebdf13011b9d264ad4f0123ea43f5511b7856493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d125705ace3c2036ce16df2a146ee3451f97342ec6f6e95323cc6dedd9f8c020"
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
    run [opt_bin"gitea", "web"]
    keep_alive true
    working_dir opt_libexec
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