class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.2.1",
      revision: "a470182f2a48e0e03ed11c3c4a2026b6597ecd26"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88009bad6674d4cb3cba504495ab453a633b4dd8d86fe2c937b94d060a295f27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebe9c799ed5cd8ca3b1b9bc403aaaf114467c36120441af2902e8400ac8d5bf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfea3943de3468dda07dab7e016b59d8341dfc3d6d25fc4c770550eff36be7a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b0418011c89c20669ff1ac37b20556ea778cbf0bde6b2e32fb4c3de8f7f54dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aba7e84c509438746226e4b4d7710acde35ed614e0cb4905ca30360b435d6009"
    sha256 cellar: :any,                 x86_64_linux:  "77a3afafdf5014a15773853297dc793f553cd17b7ec89b23acf99cb476947095"
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