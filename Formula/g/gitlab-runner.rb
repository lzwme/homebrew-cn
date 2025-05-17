class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.0.1",
      revision: "3e653c4eebd35913487814d8f07de42f3b32ee2c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f9bd87da9578c07a6a99341449b0a996b9cf8d1a2838c7f2ec0ee4158e5d8b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f9bd87da9578c07a6a99341449b0a996b9cf8d1a2838c7f2ec0ee4158e5d8b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f9bd87da9578c07a6a99341449b0a996b9cf8d1a2838c7f2ec0ee4158e5d8b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ff23f47078a97e926d6a64f7941f686c10120cb28039d927f75728ce1688b47"
    sha256 cellar: :any_skip_relocation, ventura:       "3ff23f47078a97e926d6a64f7941f686c10120cb28039d927f75728ce1688b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c1a81015a8d44bcb16a79495c25e059bfd1cb525b2e66902baad63e00bc404"
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