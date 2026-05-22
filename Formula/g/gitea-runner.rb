class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v1.0.5.tar.gz"
  sha256 "103b9b903b16db865f0295f5f3a2c175eec40932b267aaa4ddc9cc8f50a9d555"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c183683c861537321866d7181223e1842e8da5daf5d894cd6da2f4b648a13be4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bffdf6b2666b825b8c8e4a6b903dcc822036b53dfffd428d9d2c38d04ec8d35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "498346fd04c438f2aa905ea2dd97e06ae3823db1b11d2187c5a47af6151325c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d581c091e84959d70e52366878b762c1e509bd7fd158fe03ca5d6ade7571205c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "295d2c7ff7a886c93c36b27bdf7c7d438b19b348b451978000322546ebbc8247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35da652d1946be88ad8e3120b0936ded01a2e6e4903cc7374761c637ab433347"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X gitea.com/gitea/runner/internal/pkg/ver.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gitea-runner", shell_parameter_format: :cobra)

    (buildpath/"config.yaml").write Utils.safe_popen_read(bin/"gitea-runner", "generate-config")
    pkgetc.install "config.yaml"
    # Create working dir for services
    (var/"lib/gitea-runner").mkpath
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
    assert_match "Error: Failed to register runner", output
  end
end