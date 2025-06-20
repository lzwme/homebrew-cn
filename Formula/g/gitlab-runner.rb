class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.1.0",
      revision: "0731d300775d6114bb4b5ffffc9f0f0af0005d37"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1477f3c830ec5067c1a00b228dead5fe8b2c3abfcd7424d4e31c286935f9022"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1477f3c830ec5067c1a00b228dead5fe8b2c3abfcd7424d4e31c286935f9022"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1477f3c830ec5067c1a00b228dead5fe8b2c3abfcd7424d4e31c286935f9022"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b81df9e7eb13c1017e9569d98a10faf82437139733f4a60731cc06fe8b9ad84"
    sha256 cellar: :any_skip_relocation, ventura:       "2b81df9e7eb13c1017e9569d98a10faf82437139733f4a60731cc06fe8b9ad84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03876038b260677274cd160093511d2070f0223bb31fdf8d4224685a337a6c44"
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