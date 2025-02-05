class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.74",
      revision: "3a673018f18e052e6dd41ecb69ea03367d283a9f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "844fbbc5c409e3ca04f438f79dd0f2cfd73d2ffb04ce4dbb413d6f7eae13732a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "844fbbc5c409e3ca04f438f79dd0f2cfd73d2ffb04ce4dbb413d6f7eae13732a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "844fbbc5c409e3ca04f438f79dd0f2cfd73d2ffb04ce4dbb413d6f7eae13732a"
    sha256 cellar: :any_skip_relocation, sonoma:        "364142e3ddca89ee1155ae242aadad8583c36d9a21648b16531cfe8ead09d33a"
    sha256 cellar: :any_skip_relocation, ventura:       "364142e3ddca89ee1155ae242aadad8583c36d9a21648b16531cfe8ead09d33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3df1554f89712a8caaaf86616be12a2a8be122fd0fffaf3c7b5a8c89b68bd516"
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