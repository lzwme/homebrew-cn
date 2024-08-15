class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.112",
      revision: "1e91c2718bf34239701ce1a03bb35df1ba30334f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdc653005d0d4c0ba4c8fef6a086ec1fa14517adb7575c458c83fae5bb697428"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdc653005d0d4c0ba4c8fef6a086ec1fa14517adb7575c458c83fae5bb697428"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdc653005d0d4c0ba4c8fef6a086ec1fa14517adb7575c458c83fae5bb697428"
    sha256 cellar: :any_skip_relocation, sonoma:         "2850e91b48504a3529ed13b46dc1caac15319191aa22c494510ea608875e394e"
    sha256 cellar: :any_skip_relocation, ventura:        "2850e91b48504a3529ed13b46dc1caac15319191aa22c494510ea608875e394e"
    sha256 cellar: :any_skip_relocation, monterey:       "2850e91b48504a3529ed13b46dc1caac15319191aa22c494510ea608875e394e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "658708267d3f749a65862fb617280c39444ac7af6fdedcddc2881ef2639d3682"
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