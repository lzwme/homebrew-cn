class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.47",
      revision: "47d36f94fd09a7dfff25f8c3eca5d8d5e2efc409"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5655afb8aaad045c1caa7d2127848c1c18ab50a0beae474bb86c25a6c6716dce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5655afb8aaad045c1caa7d2127848c1c18ab50a0beae474bb86c25a6c6716dce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5655afb8aaad045c1caa7d2127848c1c18ab50a0beae474bb86c25a6c6716dce"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a73f4bc75e0e57d2e3854e7bfc57b89377d69d4aea9f372b9faaf5a814f64bf"
    sha256 cellar: :any_skip_relocation, ventura:       "5a73f4bc75e0e57d2e3854e7bfc57b89377d69d4aea9f372b9faaf5a814f64bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d21782fcd44706793a8ef894be00b214938e8201f3d3fe63f2252ed9f4f5729"
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
    generate_completions_from_executable(bin"fly", "completion", base_name: "fly")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end