class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.3.1",
      revision: "66269445606da32c52be605feba6d70fc1a8fb0d"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddf9ad74b212afea252cffe24b2570bd8de4b034a4ea0716cfa4c73928ad449d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddf9ad74b212afea252cffe24b2570bd8de4b034a4ea0716cfa4c73928ad449d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddf9ad74b212afea252cffe24b2570bd8de4b034a4ea0716cfa4c73928ad449d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e5a4034254ad89e677140d848b711f8384e759b53ff2bb08177d3d1e27e0921"
    sha256 cellar: :any_skip_relocation, ventura:        "2e5a4034254ad89e677140d848b711f8384e759b53ff2bb08177d3d1e27e0921"
    sha256 cellar: :any_skip_relocation, monterey:       "2e5a4034254ad89e677140d848b711f8384e759b53ff2bb08177d3d1e27e0921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0453b1018739bb72a9ebff9c66d064a4936fbb8f8a204deac7cf3f10a65fe655"
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