class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v1.0.4.tar.gz"
  sha256 "2e4c72773d8374ea8c44c91480e9a337d3d55e2c7c08f37b0ba555ee6e0dfdd2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8af4851e0ccd40fc196bb6002e87316e1e8d7ca39c856bb5ff7972f14d3f4303"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "638a4b5b90748a72fa6a7cedef373a858e2ed664aab54e033ee66a1ff6a72525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c129b103120204e678b82ce7e8c7ecaef33625297cda72347265b6b19d75b62d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0697931633682c806b768175af2a7d901115e0bf5a601c37fd3ca96d87757f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f78c0941daf508a947ca33201195019c88a7143053f6cf226d22e57f826dfbfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfff30d32779c5b3103b4383eaa3e09a19de74bbf17e94eb293a804a7e4639d8"
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
    (var/"lib/gitea-runner").mkpath
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