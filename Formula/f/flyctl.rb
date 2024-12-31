class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.56",
      revision: "3a74f3f114bce7bb4bde17658412ff6343798ccd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10681309b4776706d77cf131df5a6082c123146bf1ce791c159c438e1b7250ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10681309b4776706d77cf131df5a6082c123146bf1ce791c159c438e1b7250ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10681309b4776706d77cf131df5a6082c123146bf1ce791c159c438e1b7250ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e1029bff2d8b84f0c30f7506b96de7f384ddefa41cb1e70c84a7da16107be7f"
    sha256 cellar: :any_skip_relocation, ventura:       "1e1029bff2d8b84f0c30f7506b96de7f384ddefa41cb1e70c84a7da16107be7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "438f8ea830216a15aeffe371f5d1ebd7ebf254f944e137085cbc9ccbd995e63c"
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