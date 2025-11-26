class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.6.2",
      revision: "83dc1e703f00a8a70ba42c657c71242d627081d7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4f3c9ed090526713c9734b2a8ef29836a78e50b1969cb1be602e42ddb937e1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4f3c9ed090526713c9734b2a8ef29836a78e50b1969cb1be602e42ddb937e1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4f3c9ed090526713c9734b2a8ef29836a78e50b1969cb1be602e42ddb937e1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ad47aa732485dccf2fb3db199f58e4c33da98c59808427bc411121e8c85eeba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44af64774b0963c61fe600a9915158d97fe86003565193d87c204510a6578879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea41b7152e581e67804696fe7a377f142c4773351e8814b96f52700686beb6a9"
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