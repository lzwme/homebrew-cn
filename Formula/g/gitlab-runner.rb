class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.6.6",
      revision: "df85dadfe31bd09f5029e343b00b8656a6255319"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7f5714e42f97979dd307e0abf31eed363afae4c8dcaa1da3b8c1d06e85cd823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7f5714e42f97979dd307e0abf31eed363afae4c8dcaa1da3b8c1d06e85cd823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7f5714e42f97979dd307e0abf31eed363afae4c8dcaa1da3b8c1d06e85cd823"
    sha256 cellar: :any_skip_relocation, sonoma:        "09cbc35b3c71ff9dca3dcb2d1bcb6a6bce20e028572e5ee00ea210d1228ab0ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32517c36800ffb1d29be6f303da4beb18a27aebb94dbaebd24b4835dd94bd5a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "547102e025e53dc9ad033bf08bf2f6cbcb0e71c162423b71e9c0758ab6d73e24"
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