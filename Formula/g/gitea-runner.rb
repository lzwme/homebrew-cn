class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.0.0.tar.gz"
  sha256 "75560f121a7498a466cea45fbf277d910f907a41b13e872ff3a5a51bb60d2d27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adf23b10b07dfe08eb46854d18250fd0aaf9a3de5ee0f9592083b253b0c54eaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d02ef95116d1f3a602e634bf6148e809eaf5c31f6d14ed75d6d3f498c8047f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3653b510cd52fa51444041587305bfdb07232d77254f24b33f33018b35a1f8b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3314af4ac2582bd2d897b99d8e8adffab539eb65f7348815debfc7865e7dc0c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8d1d801ca4e90c77ee5772478a5f4bd64758c02fdc3c9e62bcf998ac63af86a"
    sha256 cellar: :any,                 x86_64_linux:  "66be8d324845490fc9f8c04e87012e52d7511a7037f67d4a9a122d63bb9aee8a"
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