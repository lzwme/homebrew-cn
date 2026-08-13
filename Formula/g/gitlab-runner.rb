class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.2.2",
      revision: "343288f1214ac954d32f1c60ae3855f2d7b0afe6"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca7e27e4001b517ca06c13b90f2c5e0a0f4cf03c8ec104c472077ef2852f9238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10080f136cac5898e847846a6631047adeb66168af1c5e09463a8070269c6ab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5c9e2e99e53fd5398b18c3b8b4ed60cfd14035008ac9035d4224a01ba3ec31"
    sha256 cellar: :any_skip_relocation, sonoma:        "f019bf9c7412276baf19c56af917675e77fa385a607c9b92af49519be4039878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3941a0548103fa6a426d764f6897317d4929f766e4873563e7f856a85688f502"
    sha256 cellar: :any,                 x86_64_linux:  "cd2a702984a8b797a5c234aab5b57dfef001338e40a9ab365e5a1014b69b0001"
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