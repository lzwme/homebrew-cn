class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.89",
      revision: "3e80fefa913be2873d3e03ac5b9f1fc2447ef430"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f105cd3e0afa234ea7a670429ae396b1c2ea7313f43847bc9e8ccf73c785c3e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f105cd3e0afa234ea7a670429ae396b1c2ea7313f43847bc9e8ccf73c785c3e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f105cd3e0afa234ea7a670429ae396b1c2ea7313f43847bc9e8ccf73c785c3e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3606b97f12c8d04399e119823e874b60743dafe7de57039777d791693b9c807"
    sha256 cellar: :any_skip_relocation, ventura:        "e3606b97f12c8d04399e119823e874b60743dafe7de57039777d791693b9c807"
    sha256 cellar: :any_skip_relocation, monterey:       "e3606b97f12c8d04399e119823e874b60743dafe7de57039777d791693b9c807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9193621a15976b6eded181f9a4acadddcd826b3124a023d986ca653c6244c7"
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