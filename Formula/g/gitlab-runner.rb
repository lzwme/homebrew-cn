class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.9.0",
      revision: "c4cbe9dd7840ba5fdbd4cb08252983544826a485"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ae45f24db3106b84c0064b36513a633ed541b4e0e70862615412d03c8255595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ae45f24db3106b84c0064b36513a633ed541b4e0e70862615412d03c8255595"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ae45f24db3106b84c0064b36513a633ed541b4e0e70862615412d03c8255595"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8583709cc92637ed7d106d764e9911b5b3286d9fda00db6ddf4c635c4c667a0"
    sha256 cellar: :any_skip_relocation, ventura:       "b8583709cc92637ed7d106d764e9911b5b3286d9fda00db6ddf4c635c4c667a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f76e8a4ae2c979bc39883e7142e65febc87163b60c0116ebc74da3bde098e80"
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