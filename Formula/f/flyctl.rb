class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.99",
      revision: "aa6171260b8dc91e4992afb5d65da0d8982d7f68"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a6e19fa12de383031bbd0ecdef2ca65c29812b4b30a1c0f9af5b903d9164280"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6e19fa12de383031bbd0ecdef2ca65c29812b4b30a1c0f9af5b903d9164280"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a6e19fa12de383031bbd0ecdef2ca65c29812b4b30a1c0f9af5b903d9164280"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3329c01fb692947e68431b4378cb1d96f1734ae5a3fadde91bfe00d64bd924d"
    sha256 cellar: :any_skip_relocation, ventura:       "d3329c01fb692947e68431b4378cb1d96f1734ae5a3fadde91bfe00d64bd924d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8c8c87548bd104c1446f777777d0d65cc02ce0cdd9abf462a678905ebc76fd8"
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