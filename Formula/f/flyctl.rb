class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.158",
      revision: "65330ff8e460c7ab6e1622c81aeeff369c16d2ca"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f2425f9e49d2ec064b46e21c395f89b8ae9f47f991283931f3537171f9de0c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f2425f9e49d2ec064b46e21c395f89b8ae9f47f991283931f3537171f9de0c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f2425f9e49d2ec064b46e21c395f89b8ae9f47f991283931f3537171f9de0c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd01f95aa71576862c708dc2a60d6236c8cd6da1ec8540b47bb979a455b28d10"
    sha256 cellar: :any_skip_relocation, ventura:       "dd01f95aa71576862c708dc2a60d6236c8cd6da1ec8540b47bb979a455b28d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c91f8bacbb11408add96ca322f236ef14a26b511c8d5e895432741ecc2f6a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc200be6f060006d5c3cf00c16cf5d33379dca6a4e29c647d0aa185d757279d"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end