class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.6.0.tar.gz"
  sha256 "01ea17b68ebe43e223ddaf1482e6d76c3dcb063a5cb23e1bf22138868990e375"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cc87b84f4cb286521c5aaf5674db61dfe4430af061585aba0310c6290c22aa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "883f70553701a22676156e44363231f8d3d1f94b8940e2bd98cacc453ea3e037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42ba7991a46530190e2ec1395fd2ea10086df01b50933bc5b3999508ea74126d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e275ccb4a68106b86924d37195f5e339a73dcf03c3aa638e582541f5baedb37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63470e226e77687eec119e1cf77df8e2c3b95b6a214d3f09760ea6685266ebfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f8bb67f3bf0210538c19add42fb07847640c7ab4ba9825cfe8442f19ee9b34"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X gitea.com/gitea/act_runner/internal/pkg/ver.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"act_runner", shell_parameter_format: :cobra)

    (buildpath/"config.yaml").write Utils.safe_popen_read(bin/"act_runner", "generate-config")
    pkgetc.install "config.yaml"
    # Create working dir for services
    (var/"lib/act_runner").mkpath
  end

  def caveats
    "Config file: #{pkgetc}/config.yaml"
  end

  service do
    run [opt_bin/"act_runner", "daemon", "--config", etc/"act_runner/config.yaml"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env

    working_dir var/"lib/act_runner"
    log_path var/"log/act_runner.log"
    error_log_path var/"log/act_runner.err"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/act_runner --version")
    args = %w[
      --no-interactive
      --instance https://gitea.com
      --token INVALID_TOKEN
    ]
    output = shell_output("#{bin}/act_runner register #{args.join(" ")} 2>&1", 1)
    assert_match "Error: Failed to register runner", output
  end
end