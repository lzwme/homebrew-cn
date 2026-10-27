class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v5.2.3.tar.gz"
  sha256 "59dcab612594a88ab346cd92889af0fa050fd25a4ac18ba715421fedaec19f7f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e8ce6b349c50614efc4fa5ff8a6e4cb24600193fe8750a40e7b827aca1bf1f26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5945435b139c20e508b7d0b1451fde9a85e1c4d7a16126baec6f495d1c4bbf07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f60adfbb25e817d401f131ec5cd4744124c23a0d2592107f9815aab8c57fea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "396877512398e5ff72d2b19d14ce734821fd37f0311aec44a8ccca483a1eedb7"
    sha256 cellar: :any,                 x86_64_linux:      "75fab7c8f8cc5b8efcefb5c3edd06696ba0f52bb63cbaa62cafd61b70ef1f923"
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