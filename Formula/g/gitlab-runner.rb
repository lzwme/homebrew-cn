class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.2.1",
      revision: "9882d9c7bcb386e9918651c7b1042832bd59e5d1"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59a1aade03748fb3b2f8d083ff65d9dd3195d5898407941e2aa1f42c7b79dd18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c703a7b3274c1faae38e5323550befc5763794e135a635c3afcfe5c137ea4529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef4d854d7cd2f49c886a647dad029c4766dbbc35cbe9548a851739124c604dd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "15bd2dd6014db666ae590eb74b3bd318cecdd949f1d56f450862966fda29d3e1"
    sha256 cellar: :any_skip_relocation, ventura:        "ab7f39d6fb47b0b916cbacf37ab055184ed146f1456f99d4b006306e118435c2"
    sha256 cellar: :any_skip_relocation, monterey:       "339e6514f21fc47627e6f69dac91862c02cb5f9282f97f8b678023ab61c0e640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1a6fd21137b8ebb9f9a5b38a218e7aceee9a7270a1541a1a6a48647a62b1786"
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