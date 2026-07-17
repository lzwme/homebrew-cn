class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v2.1.0.tar.gz"
  sha256 "dad85587fbe697d62cefa7773ade942318a0c291edbcc7f7a17bf80d52b76798"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "157504a5cfc0c1b73d2ac211894b50da8252982a515127d698cecfd44b69640f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad5f0e9ed378541f4c469a784ebbbad34725f9ac35b89d889562f05d88ea2f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cb92da0de8d14f40d67257213ebc4b7e3c401898471a3c716e1613558e576a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b60f374442d5c3b8e83b3637098e2ef58c6f67524dbdca244f4856113e116b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "781c6bfee8f3e86d6c9101fd53fc89012199a764c903c9a9ce4d88f3ba155171"
    sha256 cellar: :any,                 x86_64_linux:  "f19d8e3bdd4fc8458e490e4d777164013ecf81e0eb98eacb492d358c72b661b0"
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