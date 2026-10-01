class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v4.0.1.tar.gz"
  sha256 "9a88166a950018ebefc83977add24ed34eeee29938d62241d9c3ed941f40b5b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf2927fc24357b70377bcb8b9b87cdcc29418cf967c18cf76b6ccd7de1df024d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "731eb86f5b63abed1494889ccc6f17f361b57b94eefbd54d31d881aa39fa567a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5ed69f7718d7aa139d2cdb5d94210e91bfe00c8a925fd728de356a9b311cba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "09a45f3f16446ee3189e0eb6ce22c0e34eb12c2a9b6a3baacb3760c258616e1e"
    sha256 cellar: :any,                 x86_64_linux:      "4386ceaad01c0ef262c7bd6aca3a99508ecd85fbce2ae6ed659ef1888b8a0159"
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