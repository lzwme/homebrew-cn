class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.0.2.tar.gz"
  sha256 "9c57d77cf3c6bf79041b02c200ae6f7446f9b3b1a02495ac530dc90dd309496e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42436d4f6c099940c1dfdeb3c9aab7534aaa257abb5ceb672e86e25f9963a990"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5890614e33fc2217b73e40cdd6f6adb2c91712223ef9524f364b6617f86d2cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cdf94cda6a3051f073a28fbd5924511875d45d2495ce9401e4ea1ca6be71050"
    sha256 cellar: :any_skip_relocation, sonoma:        "afc83b763ee80c0e1a600ceb71d3f973674986bb72fb68838b035545aa62dcdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0441fd87b5ca3c4ef1984284fb73752c401b188a8752c6160e12f4724fdede70"
    sha256 cellar: :any,                 x86_64_linux:  "3f4f4150b45ed854a87696c3387acde599baa12c0fca752f276f3e463b81520b"
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
    assert_match "Error: Failed to register runner", output
  end
end