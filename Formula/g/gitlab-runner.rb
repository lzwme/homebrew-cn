class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.9.0",
      revision: "07e534ba6823a0922a97563bf9eeabbe5b233a61"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7e8fb04c9267c7164c1ba5a1550125ec6914921803d283e53e29af1a547064d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8962f92df5ae1a20ac32917dd8f32670b1aab6843c4edb28341b4df65d182549"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2790ac2e340e394241b4b67c2b06fe4de1c90818b6c6c2224bcf29d882d3217b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aebd15c694caa4bd3e8c584d324c6cff687ee43fab7867171008fd660d30a308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "859fc59292a53733a89f298ca9d0ac785740a5c4fdb1141380307063b02fe4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "796d91afe57c597012ac295c39a5b1c5a000b5ea9f75c6bd06f0fb253da07512"
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