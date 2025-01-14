class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.62",
      revision: "19bb3e6cf335341d19372dcea931ec790dc8e50e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59f004c8e8a9e87c388b3ef9cf1f3eaaf0c3dbd20a9badf70641dbaa76168bd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59f004c8e8a9e87c388b3ef9cf1f3eaaf0c3dbd20a9badf70641dbaa76168bd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59f004c8e8a9e87c388b3ef9cf1f3eaaf0c3dbd20a9badf70641dbaa76168bd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3834ade710a163d7220181e5c40c117f049a7c5629e6386c1ee4b7dd1492c4b6"
    sha256 cellar: :any_skip_relocation, ventura:       "3834ade710a163d7220181e5c40c117f049a7c5629e6386c1ee4b7dd1492c4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7059d767e09fc2ee54b98b3597ecb10d578ffa03733a555890af576e9bfbe1"
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