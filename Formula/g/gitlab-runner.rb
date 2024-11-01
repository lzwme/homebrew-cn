class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.5.3",
      revision: "12030cf4e1c6c9f8bc5a1e6eb515d7884e20f5c4"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03d47069864491a02df2dec061486368201ea555ef905867b20d42b79f6fe106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03d47069864491a02df2dec061486368201ea555ef905867b20d42b79f6fe106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03d47069864491a02df2dec061486368201ea555ef905867b20d42b79f6fe106"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a9156b18d2b1f13cc601031c605a940fef8504e0916450edd87fb47d366735b"
    sha256 cellar: :any_skip_relocation, ventura:       "1a9156b18d2b1f13cc601031c605a940fef8504e0916450edd87fb47d366735b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2df23a8c223d29ea28a1103ea478b884346fbf19ac31bbdda47f26bbd9bd5aa"
  end

  depends_on "go" => :build

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