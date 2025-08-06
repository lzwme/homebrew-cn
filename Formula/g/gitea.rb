class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.24.4/gitea-src-1.24.4.tar.gz"
  sha256 "e435383dd9e6cfb14b13f8345f321442fc2fe6b4f5e3d24c84ecbfd1073542a2"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2de7e5a101facb3d0bdeae8ba785c087303d602290b8eef7e9d8b2934b0e020b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39981dd590c878a2f1e31c1448083780909c24cc4662d683d27446efed812a01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4ee470ba3f0f42b10172e1a19dfa13d759e9fbe80c7656f6a1b592b17a4c6c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "80545d4fabd89c2210de96a8e4dbfce701fc2935fefcdfd25d19a1f270da2de4"
    sha256 cellar: :any_skip_relocation, ventura:       "61cff0d43ee964329bee736f1ba365e13791891b088b54535a91c9decc4051ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a63a939c3bc1683da7faa37b2906b4760a0d42271cb2cb7d81210b2e7ee6dab"
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