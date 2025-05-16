class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.0.0",
      revision: "d7f2cea7c6a4b0e82fef6641319ec17216d12c59"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0452ed01d857071100ab4d43f00ab07ebb01999ea8e67d7b182532a99daa52d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0452ed01d857071100ab4d43f00ab07ebb01999ea8e67d7b182532a99daa52d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0452ed01d857071100ab4d43f00ab07ebb01999ea8e67d7b182532a99daa52d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd587d7a9638da028ee33018b00f8aa0ea23dfd5bada59d9ca2df5ad5a729b83"
    sha256 cellar: :any_skip_relocation, ventura:       "fd587d7a9638da028ee33018b00f8aa0ea23dfd5bada59d9ca2df5ad5a729b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1af6ce170cc2381b5f988f84b3280bfeb4e4d989c2573d6433673ad4c54262"
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
      -B gobuildid
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