class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.4.0.tar.gz"
  sha256 "f1b4eb8538ac330c0c42f8177a149bbf71e39f0546d1be8074741e222eff4a9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14710ad93116d85235c6bd84a19707874654a7bd7d84f570a5f156a1e3a68917"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f702fc72ea8ec746fdb60085fa28f8b28298baed56ed03f8f7ca2cea43e2ebb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f80367f792dec0b36787ba72210ee2f9a86ff12439b0969530a917827731e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "c51a136794d24728c9366360e8ae8283d561608c1c485541196745c8f19f8cac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3d30987412b1ae22bb18b356a2d2b8e247587eb922509739a156e773e811ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5edb32752aa218faa329d6578be7d797870be75ee3a5c05b14a55fe7e855481d"
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