class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v5.2.2.tar.gz"
  sha256 "4f56d45548ceae40c5814e4c0f014d86b42e5966c69592e292cd21c01bc050af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f51cbaaf4e5ba74218154d6513a06e4d9a682ebbb0649f1700dfeafb682f262"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9e0f8bb2d8824a22dfcb7fd46953d926ea6f2ab81e6fb0e96836bc6403188cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33f4f6dd17c754a77cc44a30d1735d5c6bf0523a52d6534733ec1d55a8cf1512"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ca3571c9ad45b9e034c2e3196a0d6c4e7677edf92645b6a76db0a45471cde83"
    sha256 cellar: :any,                 x86_64_linux:      "eb9e22962ab3488f0de0231d7370faa8beecb90832cbe33517a82f9e4ef7cf1c"
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