class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.130",
      revision: "0f9821eb00e1ac9ab2de4f7ea34fb28a7293736b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d6783b01ad8c1acd6ba4e0df3c3c2f8aeb8c0fca98c43a02a27fe9b2d47beae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d6783b01ad8c1acd6ba4e0df3c3c2f8aeb8c0fca98c43a02a27fe9b2d47beae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d6783b01ad8c1acd6ba4e0df3c3c2f8aeb8c0fca98c43a02a27fe9b2d47beae"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb02d78043df53de9a6cda686c540599c7ce65d4deda401c812b354b2777b7d5"
    sha256 cellar: :any_skip_relocation, ventura:        "bb02d78043df53de9a6cda686c540599c7ce65d4deda401c812b354b2777b7d5"
    sha256 cellar: :any_skip_relocation, monterey:       "bb02d78043df53de9a6cda686c540599c7ce65d4deda401c812b354b2777b7d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a17f6041cf22e87db3fba3cace0f69dcfa64f3ee576915cd420bbac4f62d431"
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