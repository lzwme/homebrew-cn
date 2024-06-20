class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.72",
      revision: "df7529f6da985a662853ffc7003f57ee3c9d8e42"
  license "Apache-2.0"
  head "https:github.comsuperflyflyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a179e62679569c69324fa86403b317a9592c19519c0b584ed1370494ba0a672"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a179e62679569c69324fa86403b317a9592c19519c0b584ed1370494ba0a672"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a179e62679569c69324fa86403b317a9592c19519c0b584ed1370494ba0a672"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc2b5a65602288203ed3f8d61d13c76cdae5c44f3321638919a84ad2c4187dbc"
    sha256 cellar: :any_skip_relocation, ventura:        "bc2b5a65602288203ed3f8d61d13c76cdae5c44f3321638919a84ad2c4187dbc"
    sha256 cellar: :any_skip_relocation, monterey:       "bc2b5a65602288203ed3f8d61d13c76cdae5c44f3321638919a84ad2c4187dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "293811dd445f80527e59f32860e807be06a101646e48fb1bfd701661e3bac259"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comsuperflyflyctlinternalbuildinfo.buildDate=#{time.iso8601}
      -X github.comsuperflyflyctlinternalbuildinfo.buildVersion=#{version}
      -X github.comsuperflyflyctlinternalbuildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end