class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.40",
      revision: "2aa6a1d61fd5a15f3381e5fbf245b860847c7dc1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce87913ab4384c41933e10add4fa4f51cfb12c00dc0f1b225e539b9c72c4d397"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce87913ab4384c41933e10add4fa4f51cfb12c00dc0f1b225e539b9c72c4d397"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce87913ab4384c41933e10add4fa4f51cfb12c00dc0f1b225e539b9c72c4d397"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5c7f78d0e7d8c56fa63d862d4375436d39cb9a9567bb2fe4cc5901ecdd5a54e"
    sha256 cellar: :any_skip_relocation, ventura:        "d5c7f78d0e7d8c56fa63d862d4375436d39cb9a9567bb2fe4cc5901ecdd5a54e"
    sha256 cellar: :any_skip_relocation, monterey:       "d5c7f78d0e7d8c56fa63d862d4375436d39cb9a9567bb2fe4cc5901ecdd5a54e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f38c0d7e70d9fe197dfa202a62b8894e6bcc0ee9f62c6274c18b2c545f48821d"
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