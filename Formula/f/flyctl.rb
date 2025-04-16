class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.105",
      revision: "f6a317fac815dcd70fb3d2ef9dd6e68a4a790296"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a71a27e748206d98a543067be4b662830f12711ba597551e2aede4898108e9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a71a27e748206d98a543067be4b662830f12711ba597551e2aede4898108e9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a71a27e748206d98a543067be4b662830f12711ba597551e2aede4898108e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f37697046fcdcc0f4a09c1bb314a020e7e7a33489422d20d9bab36a73eb75df"
    sha256 cellar: :any_skip_relocation, ventura:       "1f37697046fcdcc0f4a09c1bb314a020e7e7a33489422d20d9bab36a73eb75df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8266f1fcafa9c5d900a44b4e988b29049b473cd373b705e7541a03e8a02d5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f732fa82d18d3c51b4d8bca0dfbbc2f7aba2ee8ceac8034d0c96a77e40206b4"
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