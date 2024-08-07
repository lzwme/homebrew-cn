class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.107",
      revision: "87aa565a15aa220c2e846453279417724658a598"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7c7f5dc96e9a54cd32553a6ca2ba373065063fe6a197ff4a8ea95fe49ad3011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7c7f5dc96e9a54cd32553a6ca2ba373065063fe6a197ff4a8ea95fe49ad3011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7c7f5dc96e9a54cd32553a6ca2ba373065063fe6a197ff4a8ea95fe49ad3011"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a79963f9a8bf350a13c1ba0752c7f97f0923603d48b4ad5ef7af7d3de850869"
    sha256 cellar: :any_skip_relocation, ventura:        "8a79963f9a8bf350a13c1ba0752c7f97f0923603d48b4ad5ef7af7d3de850869"
    sha256 cellar: :any_skip_relocation, monterey:       "8a79963f9a8bf350a13c1ba0752c7f97f0923603d48b4ad5ef7af7d3de850869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ea175164c7ed99080d35bd35a56a4da45a49feaa93dc8987f829056fcaf140"
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