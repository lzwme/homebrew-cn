class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.0.3",
      revision: "4e717029caf97ec9d98fb87cfa7cee462ac0f81c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d58629f88bbc2d42478a8104a1526bee5bb1e637812c7dc5b2f99052b8ee8ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d58629f88bbc2d42478a8104a1526bee5bb1e637812c7dc5b2f99052b8ee8ad1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d58629f88bbc2d42478a8104a1526bee5bb1e637812c7dc5b2f99052b8ee8ad1"
    sha256 cellar: :any_skip_relocation, sonoma:        "05f2860f67d01b15cf9541473423a066b1afc41d67610a4ba177af5b9c5712f8"
    sha256 cellar: :any_skip_relocation, ventura:       "05f2860f67d01b15cf9541473423a066b1afc41d67610a4ba177af5b9c5712f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "240b30e55d3c679f2dd039cefd4da1f350005cacec4075bc28faec16ba95981d"
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