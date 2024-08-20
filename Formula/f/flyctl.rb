class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.115",
      revision: "885dd16968f060901ae19354cfaa190f5a19f710"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2710fb6696b031c683ee84c68c5095d1f187889ad01ddc2c9bcab899e44100a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2710fb6696b031c683ee84c68c5095d1f187889ad01ddc2c9bcab899e44100a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2710fb6696b031c683ee84c68c5095d1f187889ad01ddc2c9bcab899e44100a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c35d03160724136c7b01b2264ff81f233f6f8b19774c30043e4c2dbe3e80aaf"
    sha256 cellar: :any_skip_relocation, ventura:        "8c35d03160724136c7b01b2264ff81f233f6f8b19774c30043e4c2dbe3e80aaf"
    sha256 cellar: :any_skip_relocation, monterey:       "8c35d03160724136c7b01b2264ff81f233f6f8b19774c30043e4c2dbe3e80aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf96897b6ff9840580372a43eda1a43a220e54ece2260d7b3e00265f957dc66b"
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