class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.3.2",
      revision: "23a5dafcd67321b432c2a823c5db1d448666ddf3"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f072aa24e76955ab13dde9fb7a278d0a483d3c55a566b41deb201944677f400e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9eb3db26f2b7f637d17cd0bc1960cd8d5e4216a9d239f976ee28bd38dee89e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662d2154378c18a0fb4b65c26d5ad0901a078d286200c7ee6de1f9c151b6049f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6afc906496ada5cb5cca299b7f9def77b3c517df9b5f9c8bcdaff30cf6a5fe82"
    sha256 cellar: :any,                 x86_64_linux:  "0e55d843c91c55b2f19c117427ca9f7245699189e652f8debd30b91060238a0b"
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