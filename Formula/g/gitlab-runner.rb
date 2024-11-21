class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.6.0",
      revision: "374d34fda25904c34e29770b2027cef3c2cebc21"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c208bea589236ffc032b55ac6a262d81c769c00fd19ba6fcd83c36f6b72c1d13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c208bea589236ffc032b55ac6a262d81c769c00fd19ba6fcd83c36f6b72c1d13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c208bea589236ffc032b55ac6a262d81c769c00fd19ba6fcd83c36f6b72c1d13"
    sha256 cellar: :any_skip_relocation, sonoma:        "65cf73f7123a040d5893a4eee649cc8070af9e6faa340953f3d0a3f52c302a2b"
    sha256 cellar: :any_skip_relocation, ventura:       "65cf73f7123a040d5893a4eee649cc8070af9e6faa340953f3d0a3f52c302a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be62775d5c32fa987eb9c322929c7124bb2253c9bf8d4bf274c646db795977d"
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