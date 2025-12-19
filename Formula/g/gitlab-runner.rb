class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.7.0",
      revision: "901991dd22896ca37d58f46f8107bafc30fe2384"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b52fe5eec1d941ecc31ec7dbab1fe0fbb095bbd1c1e729ab469d00cb1135a8f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b52fe5eec1d941ecc31ec7dbab1fe0fbb095bbd1c1e729ab469d00cb1135a8f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b52fe5eec1d941ecc31ec7dbab1fe0fbb095bbd1c1e729ab469d00cb1135a8f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "457a9076c61ec937c163a723c80fdb3e121103416e82feac345cd66b121a21fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16db84b54eccc93d9e745709133e270d334cdcaeae07cbf6f2c9af05edc5b30c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f94301470aa8ff8aad5956d692506a12f2e9d51b10511820b4f9991bbdfabd3c"
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