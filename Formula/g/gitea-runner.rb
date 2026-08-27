class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v3.3.1.tar.gz"
  sha256 "a0146974eacddbb167e8316350a4b1fc1fa3010730866ec646ea660c008dfc67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2833b420377c208be1c221bbc20ec7e3fdb1a5537fb55692316cc6ebc562bc34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dd9ab49828aae250f4f35994ed46340631d037139862f3e98ffd432d8304b96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c39def51cdef01f8f195644193dbd170ef1f397602e020c375ea81def1792846"
    sha256 cellar: :any_skip_relocation, sonoma:        "7241272116567093d086a0d00b6e1f119f42bda666d91dc21ebd7ce0d3591d3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e1f822c036a728d78c986e087b669fa57d6fa008197567a19407294508ebfcd"
    sha256 cellar: :any,                 x86_64_linux:  "d8b68706754f756a55f73e7177beb51b4a8093ae6f2758e2fb21fae7413a1629"
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