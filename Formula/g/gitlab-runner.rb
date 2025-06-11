class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.0.2",
      revision: "4d7093e1e4eb37e77441dc0f9c83e0af7a9d4180"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499f68ed5ee27e70230e6e48ec4cbd603321b9b43248e81480c73c2efc057ff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "499f68ed5ee27e70230e6e48ec4cbd603321b9b43248e81480c73c2efc057ff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "499f68ed5ee27e70230e6e48ec4cbd603321b9b43248e81480c73c2efc057ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8743302af7dc3a627a061500b532e178a779c8e80b54c97015006be9ca4d3c0"
    sha256 cellar: :any_skip_relocation, ventura:       "d8743302af7dc3a627a061500b532e178a779c8e80b54c97015006be9ca4d3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "495e47f9cd7a8cd745bdb8cdcf85bbe058482b14e4091847e3d6f440eab7e837"
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