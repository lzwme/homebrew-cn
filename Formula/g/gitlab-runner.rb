class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.7.1",
      revision: "cc7f92770f967be5f7d0f5612d6b131af3477a57"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1597203207c1199ef20e9d9d2d5403cac9e4dc8d18d988e95efe071db33bcb84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1597203207c1199ef20e9d9d2d5403cac9e4dc8d18d988e95efe071db33bcb84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1597203207c1199ef20e9d9d2d5403cac9e4dc8d18d988e95efe071db33bcb84"
    sha256 cellar: :any_skip_relocation, sonoma:        "1da602da0515d559bd93f88813d7fc0ddb1ea009cf8b4d4b0a288bd378013ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe916b0d657a36080628c03e17afdeb34224bfecea2aa00b4142318535d27946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07de86ded9222735482671de724897967b173dcd8513d5a85eee89a2a1f6688d"
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