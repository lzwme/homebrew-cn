class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.1.0",
      revision: "fe451d5a3074a4027e281a3a2eb49a1b55465a9f"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ffa2d6a85c297f37fba84f4c6221016649efbb78eb521b7e6acff30af22458b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07238a3e9c13875326fcbcb07afb0ef07303a2910f65dd59e8246b64643c2e0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07cb729d2ef3884dd6c3430f5b5e169c7745ba92c6588ec0a336c86a54109883"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ffaaead8864f0fe6175b2b1af34a2858b787c556885fb77669edd41872224e4"
    sha256 cellar: :any_skip_relocation, ventura:        "9a0c0d41b474d64f16a2676b82394728967fabfc8e1ba77f034acf23e10ecb39"
    sha256 cellar: :any_skip_relocation, monterey:       "7399f2e7fba13583c73cca23b7ee72f56cd2716bfdd0588708306ee67ab87c24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cab2495a6d7bab2da934d8f54fb8aa82cf7319b5d821a7027213753f9d037db"
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