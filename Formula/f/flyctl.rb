class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.124",
      revision: "6eec330fcf2ae83dc8bbad922db29b74cc98ee16"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41a9542d186b53dd24ca74914a705677373729be865f7553422f05a46b1fdb11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41a9542d186b53dd24ca74914a705677373729be865f7553422f05a46b1fdb11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41a9542d186b53dd24ca74914a705677373729be865f7553422f05a46b1fdb11"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ddacb7de017e6129d3a9fffb3f81f071ac1ae5b07aa42559cef495b2fd0b185"
    sha256 cellar: :any_skip_relocation, ventura:        "0ddacb7de017e6129d3a9fffb3f81f071ac1ae5b07aa42559cef495b2fd0b185"
    sha256 cellar: :any_skip_relocation, monterey:       "0ddacb7de017e6129d3a9fffb3f81f071ac1ae5b07aa42559cef495b2fd0b185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c729c993b6f1031c9d22cf24ec945e68229a4de8643004962c418c4fe2be77f5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end