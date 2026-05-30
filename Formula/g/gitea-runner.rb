class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v1.0.7.tar.gz"
  sha256 "07ba994ec7135a9845a14147ab0799a7bb467849053e41637965c19a3f600c82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce801d38aa8a24347145df80b020bd02e1746b6d038f4afcf5009aba027957a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da389b6ebdad5008234034774e19c217ef31b02b0920b36cf5e55f97f60c70ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c488fd3bb9f90a2a9501c27a2650b8d23ea3552e3aab1ecd28f86c6163ef93"
    sha256 cellar: :any_skip_relocation, sonoma:        "76f3888a2a8d5a9a62e87c2e06509003204be038bd59f301fee235ac8b9b2eb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c552a5f0c31bbd0973a8769eba0a6d59882b196298208df1136ddc0118b9ec6f"
    sha256 cellar: :any,                 x86_64_linux:  "ddaed365ee420460463725b69d39f3ca3ec06abc5bb21049e03e1451e24769bd"
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