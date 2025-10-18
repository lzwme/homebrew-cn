class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.5.0",
      revision: "bda84871762de5fb1573f4495940e044e8a5a010"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93748a090db07ccaba6ca05026517db296af78a2893b3a490e770887c0f5fe2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93748a090db07ccaba6ca05026517db296af78a2893b3a490e770887c0f5fe2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93748a090db07ccaba6ca05026517db296af78a2893b3a490e770887c0f5fe2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "484498c670a71cb8a41694113675dee3b762cad8cb6b98141d7dc12d0ba4bc03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a38715a66e82d0f8bca4fcca5cba9864a593a307b17eb95970a1218794311f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc4b097be5479eb210cd94c57e274c6166e958ea849eea64c750c0765ba0f8a0"
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