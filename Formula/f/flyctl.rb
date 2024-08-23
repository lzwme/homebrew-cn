class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.120",
      revision: "f0232893ca84c56f874780d3bbf427a654c563d3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91cff16a98329e14329a26b30aa2b009d95d024f85f38460a637956192973fa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91cff16a98329e14329a26b30aa2b009d95d024f85f38460a637956192973fa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91cff16a98329e14329a26b30aa2b009d95d024f85f38460a637956192973fa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "eae46886877934aa434c0eac830b9fc477b16ae59343a4361d06c303cbb2ad6d"
    sha256 cellar: :any_skip_relocation, ventura:        "eae46886877934aa434c0eac830b9fc477b16ae59343a4361d06c303cbb2ad6d"
    sha256 cellar: :any_skip_relocation, monterey:       "eae46886877934aa434c0eac830b9fc477b16ae59343a4361d06c303cbb2ad6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b26c44c25095f7d8b357b316aa14ea8f623dc3328a7a0275c42696fddf8c300e"
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