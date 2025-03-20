class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.10.0",
      revision: "67b2b2db6df6b66fedab519d09f5b2706f654f6b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "945b672d75a062ba0969c052348c7dca0dcffecbf603596337c36cefbecaecd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "945b672d75a062ba0969c052348c7dca0dcffecbf603596337c36cefbecaecd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "945b672d75a062ba0969c052348c7dca0dcffecbf603596337c36cefbecaecd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c501c8e403bf6f0b8cf25872038a431a134d46f5007fd0dd8e230c009110bf6"
    sha256 cellar: :any_skip_relocation, ventura:       "7c501c8e403bf6f0b8cf25872038a431a134d46f5007fd0dd8e230c009110bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4360672855589162b23ab18f8fa65239d851af1b03aaea1cfee0d6619f11eda"
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