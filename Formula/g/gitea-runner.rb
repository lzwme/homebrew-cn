class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v2.0.1.tar.gz"
  sha256 "bf1ddf19ed237936370b4225a91c932a84b169fbdb068ec2a7ede975193d91b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38cf6f69ac72b42b70fe061d69f3bd83bf5a0e9326004342ddb942c1ee743bb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce6ee53553c716a5aed597b4e3ea366c0190d37639f442eb9b7b1f092932afba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf66b1cd0fe42eb4277436d6ef8351da597e26c4f6d3967be046c2eabff28cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f5df414cb04cee15a35080f7c261d4404ffed5c00ad32082d4d9df98316414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad5a0239cba9e944d147657a9bf2206d8e313d7d3c24a68a217dd9a9f8c4c190"
    sha256 cellar: :any,                 x86_64_linux:  "4e32e4a2dd8c3ba97f8689f9c96f7f46b2f4d827ac87bbba74141e610bc5b045"
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