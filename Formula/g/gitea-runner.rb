class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.4.0.tar.gz"
  sha256 "81832f8fa14434c593388e2cb95055201e0815a2f45807742846104de42c3305"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e192d0317687258f0f8c959702b3b90752942b76338c8eab2d968b0646fbc7f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be9904d0799cba633e5a915730c3bafa66d0c163a02736b252641b4c53c89c40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd9bc3dd8013128b958062ed608351116515eaea2d11baefabed538d6ca96f33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f3dca82a09ce8d00b25bb87e8c5a3976fba5d99d94e848b049fde647a191df3"
    sha256 cellar: :any,                 x86_64_linux:  "102b5070eaa8495699ca5d72d05276aa1abbffc283ce109549be8bdaf964874b"
  end

  depends_on "go" => :build

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