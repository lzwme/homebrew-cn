class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.165",
      revision: "8487ab10d37d084ab45d5afe9e477c0f70b8f156"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b164833efb30758e49764161685137604f351845e7c7b8770dd9d291d31efc96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b164833efb30758e49764161685137604f351845e7c7b8770dd9d291d31efc96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b164833efb30758e49764161685137604f351845e7c7b8770dd9d291d31efc96"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e8afc333d1da6ad4a7d5ad0be1eebb571a0cb51dda3563ab6201e0519ac1dc0"
    sha256 cellar: :any_skip_relocation, ventura:       "6e8afc333d1da6ad4a7d5ad0be1eebb571a0cb51dda3563ab6201e0519ac1dc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd4a2ae1e6a102aefcbd5c233cc272cdb3cbea38bec027c0439d2b0571a3eb0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5de75403b53e0ea64b980a63508144cc4b684bf171a031c7d27f7fbe8aeb94df"
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