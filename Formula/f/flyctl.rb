class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.26",
      revision: "32f7fb3048a12c6552332ebb06c2c1db3987445e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa0be42458f8334732d56168455f6bdb58b4e4885a5cc1b9b7bba26a3d855d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa0be42458f8334732d56168455f6bdb58b4e4885a5cc1b9b7bba26a3d855d30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa0be42458f8334732d56168455f6bdb58b4e4885a5cc1b9b7bba26a3d855d30"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc57d242765b28bb4770b72c99ad1de8bac4de64648b1ef956ab769083e2fecf"
    sha256 cellar: :any_skip_relocation, ventura:        "bc57d242765b28bb4770b72c99ad1de8bac4de64648b1ef956ab769083e2fecf"
    sha256 cellar: :any_skip_relocation, monterey:       "bc57d242765b28bb4770b72c99ad1de8bac4de64648b1ef956ab769083e2fecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd34b8b93289a38471cf80ef22bd69a54eade2cbeb26c09592facc820f7ba8b5"
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