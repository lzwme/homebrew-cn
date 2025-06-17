class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.143",
      revision: "769a56bfc4d9ee1c8b34e184ec5be1d39f891f4d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f5a4ec19be0fc90dbcf98f1e9c7fce24c86d6a12ddce2003890167e7a93fa54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f5a4ec19be0fc90dbcf98f1e9c7fce24c86d6a12ddce2003890167e7a93fa54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f5a4ec19be0fc90dbcf98f1e9c7fce24c86d6a12ddce2003890167e7a93fa54"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f43695906e9079a49492594b9ff790becd768096dba992985ded84c0103eb7"
    sha256 cellar: :any_skip_relocation, ventura:       "32f43695906e9079a49492594b9ff790becd768096dba992985ded84c0103eb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "096c6e81b8682d93a740a82e1ef9d17a7443cc0fbd5e5531e1897f641112134b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d628c2f9268f7498314f655e4dda4360ad9afb9e7347e754797e78ac8ea2770"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

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