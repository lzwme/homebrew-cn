class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.4.1.tar.gz"
  sha256 "a3e56d09a9d2d208711a39c4ea9b2d02e17feaf9ed188fa26b9a0977b51c4859"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec291b10b53dba1ed2001f9ca96b6d5bddbee6bfe79ae479bf902974db4c2919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9306975d16938bacb25fb8bc56302c94e90920e6385770216a5bb5309472082b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3fb499cb781d4caebba1922bc4ca5362a54809b462723643e209aa03d6c87c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1124f957ecc9a6f968fea8f149552f9a76fad7cf6682d34e30bf79edf4709cb4"
    sha256 cellar: :any,                 x86_64_linux:  "e81cde682feabe4b24204bff500f3cdb767850da5e15c1c7e25d6bb32da00b57"
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