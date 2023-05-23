class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.0.0",
      revision: "3cc4d81a5ccedf3e4ab76ef44fae95f002de58c1"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64a772aae3f440aadc6c17dacbc86b2bddf6e264b233a96413133b5cd8687be0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64a772aae3f440aadc6c17dacbc86b2bddf6e264b233a96413133b5cd8687be0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64a772aae3f440aadc6c17dacbc86b2bddf6e264b233a96413133b5cd8687be0"
    sha256 cellar: :any_skip_relocation, ventura:        "376431710b7a069c6b657423c3bd2bd732d5763d460424a854b23616679bb784"
    sha256 cellar: :any_skip_relocation, monterey:       "376431710b7a069c6b657423c3bd2bd732d5763d460424a854b23616679bb784"
    sha256 cellar: :any_skip_relocation, big_sur:        "376431710b7a069c6b657423c3bd2bd732d5763d460424a854b23616679bb784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "897e02bda11a612b75d807933bc92ed10b2c03d56fefc0a06bccc6f582cad92f"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
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