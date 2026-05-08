class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v1.0.1.tar.gz"
  sha256 "05037997e99ba6e17034b4f994d87cb4d1fc5fffec5931ae3c8988ac63f0f29b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eebf72b1caf2e28c12f7e065917a5cabff8bdbe6226c3e58d2b201afbca6671e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34a25045d933429004e43f9ddf3ff254794bd8b5f3d43ffca5f4768a5e8144bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7e528af9ae3ccf84c224465016892e6258d5dfb97ea2848a6efb6858ebecd48"
    sha256 cellar: :any_skip_relocation, sonoma:        "14b58f10940433c5e05445a45bd6fa49122af7fcb4572f2fbb427133a1864b19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7913fe4b0c6c1d120ea37cdc62edf3afa34eba9eebe81818abb9c30a5a8cff00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091d4b1edbb452f2289868f13faee9203d06617ac0f3ef7f64fcad0e19856740"
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