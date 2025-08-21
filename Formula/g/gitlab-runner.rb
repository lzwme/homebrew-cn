class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.2.2",
      revision: "50bc0499e79f73f566ce46e20fa4da17d1c8165e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aab9ccd62e76d9ec3d44d0366b802791b10f32e27414250d1e87e3eff1dece0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab9ccd62e76d9ec3d44d0366b802791b10f32e27414250d1e87e3eff1dece0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aab9ccd62e76d9ec3d44d0366b802791b10f32e27414250d1e87e3eff1dece0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd44dd9671152caee2141cc1745e534522d436d913cbb0d77465b9b4b4be9b3b"
    sha256 cellar: :any_skip_relocation, ventura:       "bd44dd9671152caee2141cc1745e534522d436d913cbb0d77465b9b4b4be9b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef374e40d26b21e62e3726ea57fa17001c314b41c8056ad8cf9c231be6777ae4"
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