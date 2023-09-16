class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.3.1",
      revision: "d240d5bbc6869cda4f936368b128305808374f45"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff519a74e92e2b32718b4f1e1d63894da421fbdee6df5a4d20c8aaba53073709"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af19c8bd002d4f86a0021219c6a2f01d298f5f82857153fe1f4225d7054fb72b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f42c5f06bededa44bceb204c31ae0ccdb2e6378d19da6200f7aae0bc16bf35ec"
    sha256 cellar: :any_skip_relocation, ventura:        "407336029df8882e334e8372ef0a0d330701612acce26f8cb462997a396e7b69"
    sha256 cellar: :any_skip_relocation, monterey:       "e254872834909c2498a9d79c6b0311510b8b9ce2aa999e714bafcba8dfc644e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "381c851aed184d9e31663c2f67bc9d8f1d3cf4a6521654658da1eab32964dc34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11b2366ff84af97e847e37f2d39f99402f78b0395e0ab6c78711b8b9b04d62d1"
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