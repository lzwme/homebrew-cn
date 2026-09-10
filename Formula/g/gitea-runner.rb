class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.4.2.tar.gz"
  sha256 "427afc0b54a4f1f80c9b9732ffd687a83ff69554e233bf5051827ae0f06f608b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "355b777881796917b5188a6463a9af373ee277db70f560329948bd051168f05f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca929f105eff0c771182a65f837ebac76b9172236f52bca56db0cccecfc141a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "261e9478077d49a9cf2394809b60be8ca63c8330ef24012c6c36d6a081684841"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e7cfa382823ffa83773a8f7e9b936022c13f24663a8bb800f1d85855ad5eaf3"
    sha256 cellar: :any,                 x86_64_linux:  "b728b4b1e3178734b7beae329557db317237e3f9bb6690b42289d3ab28c791d0"
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