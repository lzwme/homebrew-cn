class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.113",
      revision: "50742d17a3cb55bb4735bfe398a0e1288a42f46d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ff6760d3661a269d8fc23a8a516c4cb2f3243666d1c12b0f7e46cfcbad4bf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ff6760d3661a269d8fc23a8a516c4cb2f3243666d1c12b0f7e46cfcbad4bf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33ff6760d3661a269d8fc23a8a516c4cb2f3243666d1c12b0f7e46cfcbad4bf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6732061481d31b7181bff2838d29c312f12111b396dd68b3b1b6b6078d1c6f1e"
    sha256 cellar: :any_skip_relocation, ventura:       "6732061481d31b7181bff2838d29c312f12111b396dd68b3b1b6b6078d1c6f1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76e41a31485ab32aada6426f45c4c9c12e1b6d073b5ff0100e9aaccda5af62d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e0819be27bbe9d130843333a8afe6f5f2efb6be40c12c688c6c2b4b2c978bf"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end