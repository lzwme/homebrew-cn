class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v5.0.0.tar.gz"
  sha256 "1361cc61e3867a43346efe30223b07b59a84db9bf0ae2a3a9434ebd35ebae1e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17a6e052c73024303c67ebdd4ffe999badab1025a974718f4633ad372ab549eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9cfb9f8e5d087a7d904f6281fcd2d707165fd9de722849dd5a11f87f52136af8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7460fda069e2497b561b91a656f2d0fd2b84ae068ae5d1cf5ea684991a04765"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4fa69ede90f0db11fb3f2605fc9896c5542b9d3f27425724a6e36f90c7c402a0"
    sha256 cellar: :any,                 x86_64_linux:      "d7c55e7a9d5d3337c8c831d270cdc708aecadce2c03844db20e59eae53e3147f"
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