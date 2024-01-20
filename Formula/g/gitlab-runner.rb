class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.8.0",
      revision: "c72a09b670c4370a9e57e4ed89697ff3ce3ab84f"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "455fcfb53a843ebf04baa4915f2a5d7f0be321d2bd98241a9967b19273df2d7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1db992ca42126caa80e4dfe6a8246971422599b44e66941bd48291ed9982218b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a174e2b7cbcc573a1c51b22a0d7fc66362ed06ad74b1268ebb7897cdb5d0cbc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c419c05f98797926908714a207aa83e590e6778dac563762ee14c7a4a0d6cf0b"
    sha256 cellar: :any_skip_relocation, ventura:        "86113b0808f1ee3f1dc8459280a281e7c755819d892c5b040615d63fc55ed5d3"
    sha256 cellar: :any_skip_relocation, monterey:       "40269d9aaa1cfcdf06e41fd64683164b8e1a90f44c20ce7557b147e9485cebe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3acd625bf06124bec6bd3ac38b906ed655a8a7a47f9429de525320bd4e726179"
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