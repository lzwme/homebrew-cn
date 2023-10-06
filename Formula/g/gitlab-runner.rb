class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.4.0",
      revision: "6e766faf8f13dff6d05d0b4617fb4744a2149b52"
  license "MIT"
  revision 1
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38b4fce6198664ce239346acd1b1132425e64160cb5182c7efecff4f285ef749"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c76555b6465eecbc49e66c44ddbee1bffef0315f7374514770e6ccdbf59b6a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6f7734fb0348280c47455095f36d2cfb8a8bcadc7718d76bf3892adc8846685"
    sha256 cellar: :any_skip_relocation, sonoma:         "07ccc2ee5af9af766f5543772478279089d8e87b9423dfec35ac7c9f809617fd"
    sha256 cellar: :any_skip_relocation, ventura:        "208273416619bd877936e67088dae4b652647fe2166ee46b3985777509c9d4af"
    sha256 cellar: :any_skip_relocation, monterey:       "11731632eed70fda68319534681b3d0823cead9f16135003ffc41ad5cac0a447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c1513646d923edbf5fa8106793e99d5d5f25ece462dd7d1d0eead1d4e1e3e7b"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
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