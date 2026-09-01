class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.3.2.tar.gz"
  sha256 "8f08d06598e729a6e3e97bc63b470c66ffd6e620c7e154d1bbad4644b30b06f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e31bf1c74f94a5899730407b39e5c81e53464bcd6529c07b3f5565c281db9ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07173f594aeb903a67a612addd9f294ea1b8e29988eedc24488598d241879307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff7d45a7115b9fcd6f3dc7f3b31cc098a1448e3dbade3f2585160d623412b10c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "365fe30886db0c39cf707a97ed0b985c3c480e9290d0cf0365ed45c6487bc926"
    sha256 cellar: :any,                 x86_64_linux:  "c7040a49286451d814f78403d775d0456dffe040b44a08d9a249d09b573a4a0d"
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