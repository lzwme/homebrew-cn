class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.5.2",
      revision: "c6eae8d7b606df43f78e5c1508a932d007da4c3b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fda0cc0964a789404e0e4bf8aefa46e1d684df8563fa957f89d94505d025c458"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fda0cc0964a789404e0e4bf8aefa46e1d684df8563fa957f89d94505d025c458"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fda0cc0964a789404e0e4bf8aefa46e1d684df8563fa957f89d94505d025c458"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d4c9501bbf9ae86964e8e38d6c7a5851421014c3efdd3a00557446f3ea59fd1"
    sha256 cellar: :any_skip_relocation, ventura:       "8d4c9501bbf9ae86964e8e38d6c7a5851421014c3efdd3a00557446f3ea59fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd01403e1b321c23768d6c7443c0666e7cb761e8c9768aa09d62c4b553a8daf"
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