class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.7.2",
      revision: "1c855082f3c308de9ac1dd087202b611f4b9d368"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae5e6b0247c6ed3bcc111216d7419b7c44f22197935c2c31e1444c3db7db6700"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae5e6b0247c6ed3bcc111216d7419b7c44f22197935c2c31e1444c3db7db6700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae5e6b0247c6ed3bcc111216d7419b7c44f22197935c2c31e1444c3db7db6700"
    sha256 cellar: :any_skip_relocation, sonoma:        "74bb5b018405e974f6cdab828c18d1c8faa15e066cad8ee30882b8cf16ca28df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ee0ff3aedf29cb4bc4c404c711a950f5f3ee00fcb3fb3b429faeec83379856f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7b479771259e4f210ba1642565c72c72784affe000ef7929bed81bf762219e5"
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