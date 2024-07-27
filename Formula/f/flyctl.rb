class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.97",
      revision: "b57b0b95abcc30b5fd6b4955c5c403ce61dffae1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55371d735525de4232b46c15142e982194c346b6f0d0089aac0e3e6201e50f64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55371d735525de4232b46c15142e982194c346b6f0d0089aac0e3e6201e50f64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55371d735525de4232b46c15142e982194c346b6f0d0089aac0e3e6201e50f64"
    sha256 cellar: :any_skip_relocation, sonoma:         "64d26606e8d5fd840e3a453adb8c6907be8aecd6910a1f7fe114427bb1c59b90"
    sha256 cellar: :any_skip_relocation, ventura:        "64d26606e8d5fd840e3a453adb8c6907be8aecd6910a1f7fe114427bb1c59b90"
    sha256 cellar: :any_skip_relocation, monterey:       "abdbdb23d67aee09777aec9225e64bc04d95612b7df970187513d06620e70519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecee91fdaaba1283847979c73f99bd0eecacfd7caac3b8a54072417ce9d90139"
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