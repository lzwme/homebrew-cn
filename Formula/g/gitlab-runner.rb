class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.3.3",
      revision: "03e25374d9217fe65b1a5698066982e24c2de1fe"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cc74411141a95c4d90fe213a292e7ba968cf487ae9fc1220f994189646ce3bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "019bda430e04e32d6f484359ba326a1c59358440442cc063b25739666ab824e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f5db4ad6285d5b2f9aec15052710565a2e9e79e8004e06b3d62a86767085c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a5e18c5c9c392d633eae044d7a4149774aacee206af4d47349709245c0424cdf"
    sha256 cellar: :any,                 x86_64_linux:      "2d1819f4910428167134ec6e72b1fad7e899669a33443ffffb040301200627e7"
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