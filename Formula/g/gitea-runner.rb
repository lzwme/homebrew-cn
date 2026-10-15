class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v5.1.0.tar.gz"
  sha256 "d57b3137b227526a5092a0f6ed8505d4b280a6bc08b816cfd7313e4de669cf61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "94d484d993f65b84d87ba5d4fffa99a360c47839ce4399c5e8da0dcbea7343c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2629b785f1469f05646d98273c546976637fbd3cde8bb2821d531eb29dcb7caf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a70d2611356fb90bfa50e14540a3e4c7226ef470bdd8ee2418bbcebc2e5bcc8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9dfdc2a354fae36c247848c1d7f89733d93974f095b0b1c445b28f6241c30dd5"
    sha256 cellar: :any,                 x86_64_linux:      "4e0129899b08f5ed185f7243199f7e7cf5bcea8be35d1f6030fd1ae8fbf9db4e"
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