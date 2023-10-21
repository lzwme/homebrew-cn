class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.5.0",
      revision: "853330f9dd0a8e738629e142600edfb521c61204"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ac8ed1430ecaa7515b970cdc36cdf28f23159215a785506e23e08898b1eca32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9357d9cee25ec86b08c72471b1a4d84e2480b28c6f4bf59e0519ecc9ca47be02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a79781e3dfeb34406b032a69bf91e54be5e08a7ea122dbb5d1ae90ebf5bb9ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "c92c47fe17131247108c3e8791d6e13e25315687c3992ae56930ea2208e751a0"
    sha256 cellar: :any_skip_relocation, ventura:        "6899ed82d6385fd4a127b85b395c9386cc1bcab783b08035592ee30f3e226369"
    sha256 cellar: :any_skip_relocation, monterey:       "0b26b15b484af393282a4ddf98dbecec33720dfe9a5dc0af21c5effce0ee2ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f53b929ae903ca3c04d6b6d01ad0033c03d0bb9be422286845307d8b3cdcf853"
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