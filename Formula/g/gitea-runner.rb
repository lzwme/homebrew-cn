class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.0.1.tar.gz"
  sha256 "7ce705355109db1814067eaf68e3ceb7e5a999f09a3ca5a584584a04ee05ea14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b0ce79ac589af17102d9ba7c5386aebd076383c6f408fd0d3fc7e1a24c344fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c96f37656e6dc08ef2c06eafc8a10f61ede753dd63b55b509536ef2ed6ec162d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e1cfe7a755c0ebe55a4bba322021cf1e78a0b1fcfb8f27c7f28a0a76f42f69"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f7610aeef008a20816d27a9447263842c4b7b39167806483f136c7f313e2313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9904101dfb41259a21421f89cbd02e3832c176a98c6625d599d3d4a891345194"
    sha256 cellar: :any,                 x86_64_linux:  "5d2b4dc49d730485562e01c3c87690d98e211572f16dd9dcaa8a7e5974d912b9"
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