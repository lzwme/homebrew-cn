class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v4.1.0.tar.gz"
  sha256 "266eb11b93d3378749be3c0c0860ed9de077c5dcd83441987646c6049b6ad4b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "726a494d6b3cda3edf465c7d90d4ace49c505cfae2fe9681b9b047d850e5b8dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50b3022febd459264f9dd600df5eecd1b3a31343cf784d39164fafa4d3d1d0f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1bc4fc711b4e189b6a89bb5b04f5d9bc71e2b1a28a69819417076860a289c04"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0abefdac56705c1764d7f890c6433fcdb49f4829f2e517a03a9c354d05211841"
    sha256 cellar: :any,                 x86_64_linux:      "abba8a339578acb774fd39980baec7dfda4f215cc4058615623346158a616545"
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