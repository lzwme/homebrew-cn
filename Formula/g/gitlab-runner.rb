class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.0.0",
      revision: "d4bac16c639ce0e7a778f1e88ca05b6d18dde57a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c94c8f512f5da3851d9a413088b8d566dfc3c8a5187cb4f4ca229c75b30a220e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2baa60f299e3c15fddcfb19aea70f340fe3332c108c25b8bcf0f379e05e5a08e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79f5fbfebd6657a9615ace31943f6de6cf2ecf1edc20b75014db480012e471d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b04bd7f44923ca86e123cfe3d620db8fe89a9c2d33e2a1672213654865a3ccfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67d5c109987a3d9f9ee4fdcb3111a7925b8cb5b2c663a316f15beabcc0a6b4fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfc5bc53674bf2edbd05610bfe99b72285f8151a72f62ff185f16ad5badb197"
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