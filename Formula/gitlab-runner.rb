class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.2.0",
      revision: "782e15dae28e70213e21b29f2fed257d2cf2998c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34e1515ad94bda914bdf3b0fe90a2d4964622b18f178ecf00790a8ae747c5ed3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34e1515ad94bda914bdf3b0fe90a2d4964622b18f178ecf00790a8ae747c5ed3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34e1515ad94bda914bdf3b0fe90a2d4964622b18f178ecf00790a8ae747c5ed3"
    sha256 cellar: :any_skip_relocation, ventura:        "ceea9fda1cb03b985373665978b5d912c6b9cc89a3fa326d9827991deaccc4fd"
    sha256 cellar: :any_skip_relocation, monterey:       "ceea9fda1cb03b985373665978b5d912c6b9cc89a3fa326d9827991deaccc4fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceea9fda1cb03b985373665978b5d912c6b9cc89a3fa326d9827991deaccc4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd4d6ab29ce9e7da4dab2d39e1d3c14d16feab5d04a6cd96d5ff4f1cf0e56bd0"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir Dir.home
    keep_alive true
    macos_legacy_timers true
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end