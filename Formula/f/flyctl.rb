class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.40",
      revision: "0a5966dcd8a4a7ae3a71623f9f04371a3e7f27ae"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "920f17f51a711c22b8572019f0c431152b8f90a12230d945cabd439691137cf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920f17f51a711c22b8572019f0c431152b8f90a12230d945cabd439691137cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "920f17f51a711c22b8572019f0c431152b8f90a12230d945cabd439691137cf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "929111e453312f892ff27619668a78a00890a0c2fbd900bb00758792a4588227"
    sha256 cellar: :any_skip_relocation, ventura:       "929111e453312f892ff27619668a78a00890a0c2fbd900bb00758792a4588227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfe22d4f83ab0b2a35f448e0ea8cc44536a1125959cc7490191247a917b7493"
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