class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.1.0.tar.gz"
  sha256 "15991f1c0b4b5752d5ade4d812ff395ead5f8d2b8b9778065946286dce64ec3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8081709134035648b615dbea93c375da15fe99f844717481132dd906accc363a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4042e257886f1328f020f364582b8afbd9ff829f971311242eaacf58efd94ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d241906a9cb0081dd5f576ab3fdafdfc919b90b306994bb9c7d16497fb53e53"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c0e0c9bfa7582762c9fd083da7f88bcbaf31c593e08b0ef4bcb32972b83996e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c105ef989249961015ef2945e946ad23979f2538194500e266a6131eee4067f"
    sha256 cellar: :any,                 x86_64_linux:  "644b91c6b58162d913b5e14db87cc0a22b8a49eff877382a20cb24a23d0d6b79"
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