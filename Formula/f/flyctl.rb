class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.127",
      revision: "4338c9a366483cc3eb1c4893d0a1163930a325bf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "943164917cd4fcc0088f6965e0bbc7a80ff27b9e0979e58823deb322be19dffb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "943164917cd4fcc0088f6965e0bbc7a80ff27b9e0979e58823deb322be19dffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "943164917cd4fcc0088f6965e0bbc7a80ff27b9e0979e58823deb322be19dffb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d53bb72513fc6afaef9ec762817bfa0c038cc91a19db16d408ff45e437341179"
    sha256 cellar: :any_skip_relocation, ventura:        "d53bb72513fc6afaef9ec762817bfa0c038cc91a19db16d408ff45e437341179"
    sha256 cellar: :any_skip_relocation, monterey:       "d53bb72513fc6afaef9ec762817bfa0c038cc91a19db16d408ff45e437341179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7487a3175a2abdbf788575d2ae7367b73bfc0f50b0232cb4e1388e968fc88114"
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