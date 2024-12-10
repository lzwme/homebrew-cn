class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.48",
      revision: "13b5ec32fe769dadd362e0e29bece1904f391088"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e39d754e23132e00dbbfc4814d64fb02d696368f4d4585748c83f6e1335dbe20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39d754e23132e00dbbfc4814d64fb02d696368f4d4585748c83f6e1335dbe20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e39d754e23132e00dbbfc4814d64fb02d696368f4d4585748c83f6e1335dbe20"
    sha256 cellar: :any_skip_relocation, sonoma:        "335bb7837bcf1016991e5bb51b6ad2c8f6c8c72dc6331ba105d7ed04f0e3c523"
    sha256 cellar: :any_skip_relocation, ventura:       "335bb7837bcf1016991e5bb51b6ad2c8f6c8c72dc6331ba105d7ed04f0e3c523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1962f199159c8c94c958c9c0eea40539191877e9d177f9ee13a27239043caf1f"
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
    generate_completions_from_executable(bin"fly", "completion", base_name: "fly")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end