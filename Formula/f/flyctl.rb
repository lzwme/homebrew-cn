class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.59",
      revision: "18b6e062723ae6b69bac6df481c0b4646733f627"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "047c7bb4e2cd94e3a6cc1d6b814a4f0afdb82738ad09a5e2c236cdf9d9ffe463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "047c7bb4e2cd94e3a6cc1d6b814a4f0afdb82738ad09a5e2c236cdf9d9ffe463"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "047c7bb4e2cd94e3a6cc1d6b814a4f0afdb82738ad09a5e2c236cdf9d9ffe463"
    sha256 cellar: :any_skip_relocation, sonoma:        "07d0d1757131637f15e146495ca69493a40c477da1957a44442b480a2046e4fa"
    sha256 cellar: :any_skip_relocation, ventura:       "07d0d1757131637f15e146495ca69493a40c477da1957a44442b480a2046e4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90de64cfc4a42ecc62df2312241ebb24c15ae7558df1c5dfb59bc5131860daca"
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
    generate_completions_from_executable(bin"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}flyctl version")

    flyctl_status = shell_output("#{bin}flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end