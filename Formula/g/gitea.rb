class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/28.0.0/gitea-src-28.0.0.tar.gz"
  sha256 "efb0f0fe95005f8b10f68aaaf2fc0e77540604925b51a376efcf932b9509c257"
  license "MIT"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a3ed8de85b8f119654413ae4855057d56d47ca6f96cbc61909255fb472c4f93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "46f3164a2cf4f959df5132eeb89d9f23cf3360a7909fe24b590285358d2a5819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1ce3329c28a9aa9f80b12341c1dc51fed868c1065656e2fd211cc5258f6c5fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "314c44843c769254e04d7cb4fecf952d82e175e0e6750ad91079095f4fe65f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5001bdc290bb6a76170027248a9e804e2112921d846ad94ed383961771b90c92"
  end

  head do
    url "https://github.com/go-gitea/gitea.git", branch: "main"

    depends_on "node" => :build
    depends_on "pnpm" => :build
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  allow_network_access! :test

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