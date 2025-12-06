class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.6.5",
      revision: "5908bc192c2cf236e6696403e852c518a6fd4f2f"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af7a756ee86b69647689733871c1303288460bb9f0249b39a92f2c2c335fed21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af7a756ee86b69647689733871c1303288460bb9f0249b39a92f2c2c335fed21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af7a756ee86b69647689733871c1303288460bb9f0249b39a92f2c2c335fed21"
    sha256 cellar: :any_skip_relocation, sonoma:        "450d95246918698e11e4b3188b260e9d51f8e8b0929aa51d74462afd584f50cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b0a735fe6390e25d0fcb7899463f14bbaeb7c65b6d4693f6d99f4fa13feb97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d373d5ea2d0bade7da3ddb180c9155b49d83318669f39f7f620106172690f5dd"
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