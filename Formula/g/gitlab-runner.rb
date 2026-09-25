class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.4.1",
      revision: "3c39fcebf73d01d464db3dee8a5267155273a6c5"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2986c8c7c6ad3ba219460e698745c149fd2f1a170aadfe200a014818217a0a50"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b4147120c2fec0afa2572bb0afdbbe846ac03d7ebc1373639a158238a79d556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79c87c87ecd6cef6b9bff2b5035878e14e8d3f2d99a78cbefc2738012005aa48"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7970dafae83effeb255cbfe314201bcddc7d72c6125536671382f08892431448"
    sha256 cellar: :any,                 x86_64_linux:      "468547dbb65bcb1727c82aa7778dbf9793e3513f3958be49bba0ad70e7d2ecb3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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