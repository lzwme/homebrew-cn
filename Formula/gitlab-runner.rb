class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.9.1",
      revision: "d540b510a2100dd1d17e75e89af1c921ce107fb7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13e8fe715e89c36e9eed92ec66d285110474cb936dc35b49351e727d148133ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9d363369fcb7cacf15d818f1b61331bda893d06132358be1f1f5da526e205a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57ae67186894cba9f468e62458401ac6ed4886e695595727364d39cfaddc106e"
    sha256 cellar: :any_skip_relocation, ventura:        "66a1bb0f077df25bbbb9bf3b9a8881f3ffe40f26646f3c854fd0cac63780abbf"
    sha256 cellar: :any_skip_relocation, monterey:       "69b1763adf8db22481f7f9ed3bbe02e58a3bfa22387562657a3f3d2e45c29451"
    sha256 cellar: :any_skip_relocation, big_sur:        "3df9f1ab211af3443f5285bb60b9a14442d91c52eea9e7be3efbdf0328c2faaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eb6b5cb10fcaa974cbe2458f3b840ddd020308299b1821530de0e7ec245a56f"
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