class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v1.0.0.tar.gz"
  sha256 "6fd62bda86b7775048feab134eec4d6d4fea0f08141fbc2c9526f43402247f38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "625a32c11bc143e8310228442d97a72dc760ebf80f369ca967d467cc8fc7d6e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc1b5d9811845797648017895ed4c93de0fe7f29122d1e6f81b1f84652d87e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "755c84d515ec590a3a359623183493a26966732ce3714001aee3d8d5a5842eae"
    sha256 cellar: :any_skip_relocation, sonoma:        "048895e2767538197c14d0abbd3537a3ecd2d330ffc547deb7d2f40e22eff470"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71473d79f5834abd17f897457366b89c0486ec4ce332f842f107d600fcbda436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04878457dbfd58ba76677963d7f5503a281585008793dc70cfd74e32f5250534"
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