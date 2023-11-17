class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.6.0",
      revision: "3046fee8e6a2501b9a9358e5af3f5188941d896c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00590ea49505f6c1c114fd41a828b9b6e1d6b80aae8400623e126a198ec3cca2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c15c76492f4d31c1f84f2a642b67c2b369621f228c037d05873bf5a1f48ebb75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abc03e5d234e539e740bb2421e847396fc9dde9adb9aa08b6f0831d604d0f517"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3c7112607e1802a1d72d57413a11f1a1be2f452927288be8cb99df67ce993bc"
    sha256 cellar: :any_skip_relocation, ventura:        "9f2d8e977274233498aa0267a1d4a2624c2772c2c4f7a21a9b3138e91f218d7b"
    sha256 cellar: :any_skip_relocation, monterey:       "9821429e484915aa3d0519d0876185fd01b8d9488d2b2b4e05a50fd4f481303b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82abeb163acb5ddd627c79057e0b3b640bed46402b2b2dd5ecb1d9e080be2e66"
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