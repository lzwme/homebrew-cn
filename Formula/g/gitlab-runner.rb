class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.5.1",
      revision: "f411f264f80a4870995a7c49482d02765e86c86e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7497e4e3be7e0bedcad369528d8eec8a0902cd62f01584f1be429a8b757bb2f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7924a9146b8d8909d840991cb27942e769f3aa983c92805016df72667b8eb2e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b48738d45eac006e9a47f80bdb0e4cb41ebe34399814e1491c32f651e5d03c3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "00a36a9dc723bb5f1749a0d1f5d6d29cf08c4dfd80cded6c267b57979874ddaf"
    sha256 cellar: :any,                 x86_64_linux:      "cf79afa61ac0ba380c0c972ea485ad01482a17475209605334553d7698dc322d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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