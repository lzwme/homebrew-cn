class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.4.1",
      revision: "32fe5502f91b46eb7d86c8ee5cc6f21116a8ccdc"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "083f0f2c7183feb24c0293d19d46933736abbd5ecaa9cac9cafc66374fac5397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "083f0f2c7183feb24c0293d19d46933736abbd5ecaa9cac9cafc66374fac5397"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "083f0f2c7183feb24c0293d19d46933736abbd5ecaa9cac9cafc66374fac5397"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f389f25708bf008f371f258146f81ae174dfd83ac370dc51d962387ae4d8767"
    sha256 cellar: :any_skip_relocation, ventura:       "3f389f25708bf008f371f258146f81ae174dfd83ac370dc51d962387ae4d8767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5508bbb105a5ea2eade9ce37c82debb14bd3409e8306776a0877805933993672"
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