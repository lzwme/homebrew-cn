class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v2.3.0.tar.gz"
  sha256 "391deafedb1367bd398cf8b03dc5b0bcca2182ec38dcb98054b16f737f3ebf53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ac33831321e7a1c153279c83fbfff3fb4a26bb32b35bc2b01a971d595018ef3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daa60aa69f85c7fba1623b58992dfd2a488dbfc59229ff097c2ddd4c16032611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1bef813e18ddba04eb16ea6a5a81faebc6accf5e16f529a669b67142ae09a71"
    sha256 cellar: :any_skip_relocation, sonoma:        "104d4eddeba44b6030fec4ffb58b549122fafbbfb5219ab309730018ad0aab93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "324a6b8f554cc89c0d7f6f1040f79d52eb2f14282d220a1301d971fc46f4f4d3"
    sha256 cellar: :any,                 x86_64_linux:  "8d5c2a499cb18d1d838c7bfe5dbdd8cd307f2a66b0946c4f50383c0b1b5d3714"
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