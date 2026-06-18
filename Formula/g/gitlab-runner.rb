class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.1.0",
      revision: "5eb085abb18b9c9614ba6e12951ece859d092272"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2a2d34ed3f508deed14177749358a3aac130cf92312f748eb6de6c3064a6ea5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf7c5fdf7f7a07f2d402e097d2cf28ac42f5b5a62a3c8a59bc59695479ae158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4483f1f1887efb3408b547fe008b2cd97b9648cddfa2ea6c0d88bb74f0591e1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "66253415a9e9627fc7bc6f31700ab671132af743e0426e395c0cd932bb1a62d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e49c8d767d8c49ee554d903644f3f68dee52c35f38ff2d250eaff5d804536f5c"
    sha256 cellar: :any,                 x86_64_linux:  "a86a79f39f70da38d0eb02049c8e2676dac0e92c07761204a4553533da64d194"
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