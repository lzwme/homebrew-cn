class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.8.0",
      revision: "e4f782b3301a3aca4957d9aa5a7db780d56ce80a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaa5da344832418567c4879a8d5d28a14c8d6a0736fcb8fe84ec42c70f451f48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaa5da344832418567c4879a8d5d28a14c8d6a0736fcb8fe84ec42c70f451f48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aaa5da344832418567c4879a8d5d28a14c8d6a0736fcb8fe84ec42c70f451f48"
    sha256 cellar: :any_skip_relocation, sonoma:        "2390d22f3a873bca806998ede184d0800befedb8ec98acd93f1e63dee8905c4c"
    sha256 cellar: :any_skip_relocation, ventura:       "2390d22f3a873bca806998ede184d0800befedb8ec98acd93f1e63dee8905c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d2a6a66bb7a027fa2435e9741c9e5852b170fef699b45cf1f33e526bb53c86"
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