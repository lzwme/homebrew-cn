class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.5.0.tar.gz"
  sha256 "bd85fe4b0bc93e9f4ade9af4f14c4ae951667deb443da9057ae10664fee01c25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed337e6c088dd8893a8e8b4fb7905e2d88e85a0431bb1934dd89ca1b49812adf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e565a9bd56b6dbdd59eab6d9ab3abbe030fb0150eceae277d0dcc61cbaa819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14ce74f2e99e66eb5778bfbc61f02a43d81eb5b4a3832c210e9e6f4e5bcf313b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c164c21f9f9cc57f368e1e441793da640633001ef32cc500e939ab6b5fd08b3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eae74a2b17e639c9d2bb2b9cc90205b566e2f777681f1943acf3b44124cea215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a6308ed2571dae169e3850af98066692941ecc68274b9d6675d12edc06ece0"
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