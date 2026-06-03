class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v1.0.8.tar.gz"
  sha256 "9d5b1c79149ecbf8f985f36295e766487cb2e22b0a43f778e276286e0b4cf95a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2350621e3153d7bc7f17bf64f0e509ddfc7eadf344672e488362f84fd3404791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf22941b9ac22a62e4fe7b705800f5f22fe159a4833df258034538e83712feb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "568d12b7167e74960763f25c6c1bae7d22fc276639566a934c3ec005bd02e873"
    sha256 cellar: :any_skip_relocation, sonoma:        "c44d82a9b366dfbf76e943f8d51abe22ea57a2b9570b03c80f4c252af067a65f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afff4029456bd90fabfdc73e185b347eaba642f2628cfec24654b721554590b0"
    sha256 cellar: :any,                 x86_64_linux:  "fae828cc0306d450379e6fd0213b9c9091ff3b78c719ed51ca9c5ccff4d5d4d7"
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