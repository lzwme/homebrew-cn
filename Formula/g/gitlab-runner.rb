class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.7.0",
      revision: "3153ccc6dafba6dd4aef53cd2261ebcc996f5caa"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8227b617684e716c7d6c39a37ce4cd30161d57b0a81ef862cb5fcbbd7cbf4f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8227b617684e716c7d6c39a37ce4cd30161d57b0a81ef862cb5fcbbd7cbf4f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8227b617684e716c7d6c39a37ce4cd30161d57b0a81ef862cb5fcbbd7cbf4f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbbfb8ef494d4f61a2d50aaa2b19f826b22c09d570b073fad59cc30eb9ed180c"
    sha256 cellar: :any_skip_relocation, ventura:       "fbbfb8ef494d4f61a2d50aaa2b19f826b22c09d570b073fad59cc30eb9ed180c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d340873eff562542f99be51a1a765d7b1533b2988dd0cf48a4a65c1321665f"
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
      -B gobuildid
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