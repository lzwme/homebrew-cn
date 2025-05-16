class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.123",
      revision: "9651c39a645575cb00779649c804a4b823016e1c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62c20311f1aa9813eae420079ee0d91fd6b6162ff334260a566cdd049c6b3cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62c20311f1aa9813eae420079ee0d91fd6b6162ff334260a566cdd049c6b3cab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62c20311f1aa9813eae420079ee0d91fd6b6162ff334260a566cdd049c6b3cab"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c3af745b6b873642e06da42b224ff722db3e26094a8e773247278b2f07d8ebb"
    sha256 cellar: :any_skip_relocation, ventura:       "2c3af745b6b873642e06da42b224ff722db3e26094a8e773247278b2f07d8ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "890fc2699830c892119a9dea60bf5f117eb66b317a09dcd924627421ee15c224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d72679046837b745c8fa10a4bb7f199badb4d69b5f1e215a5b22e1a69a416ac"
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