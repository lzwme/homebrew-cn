class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/28.1.0/gitea-src-28.1.0.tar.gz"
  sha256 "c833707707b6938e52da2f593c9b26b87f20c011b748e2176f608bdee436e62d"
  license "MIT"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aaf1bb1541436cdb484cff8c8557f167fcbe7d3f3354f6d178bbde174b1c89d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e44505ddf1a1d35f879c6ff5d30a46a81883c5167990bffbed2d8dc7ce3e8d37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b64f3e376d45c6730692ea177b32d63934def32fe5352ca7dbf7cfc316b2e3d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c0b898372482188d2311b74bc951dcc12155e18d2903712aa58f846568c97b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c33cd80479834cd8e5d08aecc69ca443641fcf15ac440a4503f6905a11b06a2c"
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