class ActRunner < Formula
  desc "Action runner for Gitea based on Gitea's fork of act"
  homepage "https://docs.gitea.com/usage/actions/act-runner"
  url "https://gitea.com/gitea/act_runner/archive/v0.2.11.tar.gz"
  sha256 "8b317700d1f3344d8664be9edb004914723a4aacc8f8b1b3719ca2260a5866b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8cccc7006059e30358e42621f03a27ce5628ff74456e3f81f7a02bf2922f5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c8cccc7006059e30358e42621f03a27ce5628ff74456e3f81f7a02bf2922f5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c8cccc7006059e30358e42621f03a27ce5628ff74456e3f81f7a02bf2922f5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8f417027f7afc1f87ea9fd1bb9f39f415e54ae5cc97f7ed640e0ed1ad61c1a8"
    sha256 cellar: :any_skip_relocation, ventura:       "b8f417027f7afc1f87ea9fd1bb9f39f415e54ae5cc97f7ed640e0ed1ad61c1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c6359d52d40562379404d8479db1ed2a8825c85cad93350e25be4968997048"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X gitea.com/gitea/act_runner/internal/pkg/ver.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"act_runner", "completion")

    pkgetc.mkpath
    (pkgetc/"config.yaml").write Utils.safe_popen_read(bin/"act_runner", "generate-config")
  end

  def post_install
    # Create working dir for services
    (var/"lib/act_runner").mkpath
  end

  def caveats
    <<~EOS
      Config file: #{pkgetc}/config.yaml
    EOS
  end

  service do
    run [opt_bin/"act_runner", "daemon", "--config", etc/"act_runner/config.yaml"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env

    working_dir var/"lib/act_runner"
    log_path var/"log/act_runner.log"
    error_log_path var/"log/act_runner.err"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/act_runner --version")
    args = %w[
      --no-interactive
      --instance https://gitea.com
      --token INVALID_TOKEN
    ]
    output = shell_output("#{bin}/act_runner register #{args.join(" ")} 2>&1", 1)
    assert_match "Error: Failed to register runner", output
  end
end