class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.2.0",
      revision: "c24769e865d4fb6da27d512373e2159529abddea"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e74b0649a6e1951985019dd1760c5fca2696a241014b69adb9759df316b83adc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e74b0649a6e1951985019dd1760c5fca2696a241014b69adb9759df316b83adc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e74b0649a6e1951985019dd1760c5fca2696a241014b69adb9759df316b83adc"
    sha256 cellar: :any_skip_relocation, sonoma:        "de7349253b78e56950f4b9fe7012970eda3d0654cc79ecb3a72d4e04ce163605"
    sha256 cellar: :any_skip_relocation, ventura:       "de7349253b78e56950f4b9fe7012970eda3d0654cc79ecb3a72d4e04ce163605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a8bda8d2f1817bb13ddbadc0e021494b3f64c0bb3f24bd158c453418499472"
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