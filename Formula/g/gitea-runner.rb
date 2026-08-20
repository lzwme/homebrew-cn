class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.2.0.tar.gz"
  sha256 "ddb864d468df3847842d1764f9bf617821bec69fbcc203d03ed472f2b2e4f6fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f25ba7d5b09e83045a25d4493249ac5367a69b1a839b1790b13db3e0f93630c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1679066eb7bdaadb5ca0b9eccd65b7225977a79bb7f63009efd2c762e9e3fb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3018a02b53e6634e0455b73932b4fe569d8216cb83d0fe883a1053afe0163ac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fe29b3755d7a5a86dd0868d2db7febfbeb7f7cb0f3f2a746d7cde52cc0cf649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41898d95ee55fe41b413459ece29a8e7edd0c1e106aed433276ee076911c1e04"
    sha256 cellar: :any,                 x86_64_linux:  "1a7fbbc9754e65ad5946cf8288300c48a669a1b27284485e12e65c2e537bd535"
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