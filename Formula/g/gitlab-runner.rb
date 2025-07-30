class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.2.1",
      revision: "cc489270dbc5cf7bc64c0d87f2dcf3e4fae54573"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97bcfe87d6509f938c93c430f4cbe64ad78185cdb29a9339705fbf970c63b9d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97bcfe87d6509f938c93c430f4cbe64ad78185cdb29a9339705fbf970c63b9d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97bcfe87d6509f938c93c430f4cbe64ad78185cdb29a9339705fbf970c63b9d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "36b9c77f4b0069e195ee4f8d2285805463d2ab9d4b8674708ca7919398031032"
    sha256 cellar: :any_skip_relocation, ventura:       "36b9c77f4b0069e195ee4f8d2285805463d2ab9d4b8674708ca7919398031032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c6f123831b8db332230b757b2df0b987d247e507c89ae8635e1676613566bcd"
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