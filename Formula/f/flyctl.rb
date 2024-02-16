class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.7",
      revision: "9df519aea362437a02c97f9f91ac4f1e158cb7f1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc2157a549fd68f51169c35590918413269a53bfce4ed34c28a69ac07b4c1bbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc2157a549fd68f51169c35590918413269a53bfce4ed34c28a69ac07b4c1bbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc2157a549fd68f51169c35590918413269a53bfce4ed34c28a69ac07b4c1bbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff77b75a1971b9fed1c55b29ea43023f0fab61866e180ceac61dfbf8c2da6bae"
    sha256 cellar: :any_skip_relocation, ventura:        "ff77b75a1971b9fed1c55b29ea43023f0fab61866e180ceac61dfbf8c2da6bae"
    sha256 cellar: :any_skip_relocation, monterey:       "ff77b75a1971b9fed1c55b29ea43023f0fab61866e180ceac61dfbf8c2da6bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a04d0166b86eee2776a39004b41de8885873b57b10dda22f9de224cefd7fd339"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end