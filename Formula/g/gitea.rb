class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.27.1/gitea-src-1.27.1.tar.gz"
  sha256 "2a0b401ef7a00acc2ab64e7977c7d0997030a32499ef4690118c93a8f33c9f2d"
  license "MIT"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f53c9f480b4acc42d883c0db4da37a84a664e4ea90740b18c7180e50e7f4ccdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f39bc018adbfdb8b8700f612d35e8c1bf9ded700bca098e1c6ae24703fc4f0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b3e148f53a94382d19efa93488778d954bdd6236926fa84ae0024832e08a7f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cab444f2dc6297ace8e9034fc0539785f0a6fb938ec639756573de13338c4c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1579fc764539ae32692b2154313fbce3c9fd506c41e3a0dcc03a93100ba45b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee1305b1a515826a294d9c9229e1afffd49dc82f1b50651b6fb376d797d0bf79"
  end

  head do
    url "https://github.com/go-gitea/gitea.git", branch: "main"

    depends_on "node" => :build
    depends_on "pnpm" => :build
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea"
    system bin/"gitea", "docs", "--man", "-o", "gitea.1"
    man1.install "gitea.1"
    generate_completions_from_executable(bin/"gitea", shell_parameter_format: :cobra, shells: [:bash, :fish, :zsh])
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

    pid = spawn bin/"gitea", "web", "--port", port.to_s, "--install-port", port.to_s

    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Gitea: Git with a cup of tea", output

    assert_match version.to_s, shell_output("#{bin}/gitea -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end