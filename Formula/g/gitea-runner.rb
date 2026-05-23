class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v1.0.6.tar.gz"
  sha256 "68c6e65e7cc200921a64042bea695d333015888e0693d788c8c50bc8e7b97f83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47da110cc0048fae09b35e279ad8513d3f05ae2db98439154d6f0aaa29a61ca2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "126fb6676b96c5ad6b3ef94c0ca7b5c3f562cb9dbab75e0ca18de87a49ca6c86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cf3163bcdaf98510cfcf09fc865eace8c362419fc3c444b91f0974103d7a3e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1187a5b6f5635e7be11b023bcd18f9fb0be555c6d98ac875e09bfacd77e0f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83829e3e55a58882136640e16fcd6a11b1e8dcef60ed797321fe0a34b506f6d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0734f2c69e916bb392291b19566442ec68715133fb081bf59ca36385cad81627"
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