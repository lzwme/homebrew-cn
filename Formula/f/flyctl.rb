class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.69",
      revision: "c2d7b8f7ccb88684021f227030f948f9e066864e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0034a77f54a023e4f7f881eaa5e650a5e6a15aa7f99ea2eb9fa3d333f01dc1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0034a77f54a023e4f7f881eaa5e650a5e6a15aa7f99ea2eb9fa3d333f01dc1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0034a77f54a023e4f7f881eaa5e650a5e6a15aa7f99ea2eb9fa3d333f01dc1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "226001f2c6182dad60bf21c7d5c5a47e5d4d18723cdec487ebfc6cfd2b3d67be"
    sha256 cellar: :any_skip_relocation, ventura:       "226001f2c6182dad60bf21c7d5c5a47e5d4d18723cdec487ebfc6cfd2b3d67be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f5cb78e713a4aeebb9e425697f4c4adc4f29c431abb974cf86a8e944c0ec220"
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
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end