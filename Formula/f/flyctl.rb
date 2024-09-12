class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.1",
      revision: "920d4db56eb40f22d3c58e663371fa6b1ffde9c4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67c52e806287fa545d4f19fddaa44f5c761759513b7611a1ecc1049d36c9f59c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67c52e806287fa545d4f19fddaa44f5c761759513b7611a1ecc1049d36c9f59c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67c52e806287fa545d4f19fddaa44f5c761759513b7611a1ecc1049d36c9f59c"
    sha256 cellar: :any_skip_relocation, sonoma:         "068850e9c5bbe4824c4f9172cf44183a9af1f12860a2468fcd0bee9bdbd5be17"
    sha256 cellar: :any_skip_relocation, ventura:        "068850e9c5bbe4824c4f9172cf44183a9af1f12860a2468fcd0bee9bdbd5be17"
    sha256 cellar: :any_skip_relocation, monterey:       "068850e9c5bbe4824c4f9172cf44183a9af1f12860a2468fcd0bee9bdbd5be17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6fccd4a08af54e464770872685082bdc8506c12125cfd1a5e5c8f6ba9ae490"
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