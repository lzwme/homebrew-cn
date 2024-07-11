class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.87",
      revision: "2b35303e90d4273b235bc0c5bf56f0db503d80ca"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "716824ddb9b75d9b81b299ba47245f00e3d0f6523a714927ac00e4200ea1e31c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "716824ddb9b75d9b81b299ba47245f00e3d0f6523a714927ac00e4200ea1e31c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "716824ddb9b75d9b81b299ba47245f00e3d0f6523a714927ac00e4200ea1e31c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b35b6a6a25d9396582e521d125873b1bc1e69c312aeaac393c47e1580dc11f8e"
    sha256 cellar: :any_skip_relocation, ventura:        "b35b6a6a25d9396582e521d125873b1bc1e69c312aeaac393c47e1580dc11f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "b35b6a6a25d9396582e521d125873b1bc1e69c312aeaac393c47e1580dc11f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00516b78b7fef8c2724debc6e72704c76e9f1626afc998507835fbed27b0ef48"
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