class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.1.147",
      revision: "4c5c97cd4cf9fba252937825fba858177dff24ea"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba24f634d6eb70b34f3552414068f6ccf942b4ec0158acb7c2aecb27ddacd874"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba24f634d6eb70b34f3552414068f6ccf942b4ec0158acb7c2aecb27ddacd874"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba24f634d6eb70b34f3552414068f6ccf942b4ec0158acb7c2aecb27ddacd874"
    sha256 cellar: :any_skip_relocation, sonoma:         "41774ab1f9e8ec57080b45c1905791bbc50ed4bdc8bf9aeb7b94792d9b98e4ff"
    sha256 cellar: :any_skip_relocation, ventura:        "41774ab1f9e8ec57080b45c1905791bbc50ed4bdc8bf9aeb7b94792d9b98e4ff"
    sha256 cellar: :any_skip_relocation, monterey:       "41774ab1f9e8ec57080b45c1905791bbc50ed4bdc8bf9aeb7b94792d9b98e4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d88a9f57da2d5b4dc545980b4841ec0c37fe4498dd92c96c2894ac746fc519d"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end