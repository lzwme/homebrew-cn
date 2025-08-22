class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.3.0",
      revision: "9ba718cdb6a9060dda9e3e5cd724fb5f97f27570"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0496915af6e4484c22c6f798fc2223afc9e209dff4636d61f86364ca808fb43a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0496915af6e4484c22c6f798fc2223afc9e209dff4636d61f86364ca808fb43a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0496915af6e4484c22c6f798fc2223afc9e209dff4636d61f86364ca808fb43a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f2ab7c345e2d6714587e298cee9f917c30debbce29249c9c29484d89fb27285"
    sha256 cellar: :any_skip_relocation, ventura:       "7f2ab7c345e2d6714587e298cee9f917c30debbce29249c9c29484d89fb27285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1b93a508f7836bac31fd9bf54ae8ed62ade49435e6eb0fa43eee7a0621b4a5"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -s -w
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags:)
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