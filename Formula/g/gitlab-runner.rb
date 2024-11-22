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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb61a997fbe3967f9212a8acfe4635733f04c4997926e8ede5a33e914203ca46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb61a997fbe3967f9212a8acfe4635733f04c4997926e8ede5a33e914203ca46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb61a997fbe3967f9212a8acfe4635733f04c4997926e8ede5a33e914203ca46"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bc22f032c01b041dec6ebf835b259027387e18eb88fc8a73183230caa30ff48"
    sha256 cellar: :any_skip_relocation, ventura:       "4bc22f032c01b041dec6ebf835b259027387e18eb88fc8a73183230caa30ff48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ed6ce9fbdc7cd1f07fcfde4834e02ac89ac1d875e312830ac7794fe0a7f71ec"
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