class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v4.0.0.tar.gz"
  sha256 "9cc055e08861040b7e485e1a955198ff0f1dc601abea5be2533b995dc12e2d87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe962080503c368d3570cf1a8774c41a8e44874d2cf75b051b8cfb9a1669560f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a463efa4d82fe9fa941716772a40dea4e0a387b51f8bdac761583bcc6e7f457d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a27e662259dc48ae3f1e2f274d186c0a93dbdd5f0472d2cbb16e06c5e597bc9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3be47f5963d4af7d89a7030049316d4d64eb71fdaa57afc0a1f6275e84e3bf5"
    sha256 cellar: :any,                 x86_64_linux:      "a6eca1fe506447fd009156b7104cefc81f6d7090c9ead012aa5830a1c7549e57"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X gitea.com/gitea/runner/internal/pkg/ver.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gitea-runner", shell_parameter_format: :cobra)

    (buildpath/"config.yaml").write Utils.safe_popen_read(bin/"gitea-runner", "generate-config")
    pkgetc.install "config.yaml"
    # Create working dir for services
  end

  def caveats
    "Config file: #{pkgetc}/config.yaml"
  end

  service do
    run [opt_bin/"gitea-runner", "daemon", "--config", etc/"gitea-runner/config.yaml"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env

    working_dir var/"lib/gitea-runner"
    log_path var/"log/gitea-runner.log"
    error_log_path var/"log/gitea-runner.err"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitea-runner --version")
    args = %w[
      --no-interactive
      --instance https://gitea.com
      --token INVALID_TOKEN
    ]
    output = shell_output("#{bin}/gitea-runner register #{args.join(" ")} 2>&1", 1)
    assert_match "Error: failed to register runner", output
  end
end