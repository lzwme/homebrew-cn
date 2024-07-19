class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.2.0",
      revision: "6428c2882da65b1b0974f509c082418d30e7207c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "821d32015efe15bc6cd3867b0159d6bbd9fab4a0865d4074226ffb6fa94a1255"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fb3286917d26b61c0652bd488564a280bf3359c2a55c2df48e8d6b731a07120"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d49dedc1ab47cf7238b0e418ef50199f500feda42b04f789ab7dedb672d1c2b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "96eb5ae0555f344371b6967d521ef462d5117884e84673ad2d627354afe1b969"
    sha256 cellar: :any_skip_relocation, ventura:        "0aba8fa8c56ddbe52356172a82d399089565059cf35bc71ed8decebdfda521b6"
    sha256 cellar: :any_skip_relocation, monterey:       "12a6cfc4b854377eea116552a38ef59e5dc2cd1724f6e4d519c79f478db33c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4739c2ce291fe034273168886cc330b0299f13b28fcecb2db5d94b4e7660f4d0"
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