class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.11.0",
      revision: "249f0215b976bc5287e53035980a40a1333e1d53"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57e7508975192c35a86ffa2478e9e9aad08074d2cedb3e9d1dc015712c524124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c6e00bd766656507229c049c8ab2a51a2021b58b86bb94098dea8510f6aa94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40538469c05bd01588e5729998755ea9311185a48252632d7fd6aa136ed155bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "41b33728b1a240944373fae1e26ee039ab04a40f14e000a43e14f2900612a108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdf8f30b309ba2b7af21df52df8682b7d03a2883ebb772d8d3d2afe0f6a65b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "732c9176dd5c599ebe17e97883e1b38e5f0a9d9d61e7c6351aface7d5093d7c6"
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