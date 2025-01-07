class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.58",
      revision: "6ad40187c24f867e603442d5430b3a3256885e77"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c977a8f55127696559576dbead1a6cf84d60867f6bc1cac1949ce19f26aa1d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c977a8f55127696559576dbead1a6cf84d60867f6bc1cac1949ce19f26aa1d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c977a8f55127696559576dbead1a6cf84d60867f6bc1cac1949ce19f26aa1d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "280e7c0c4b643b7d4d775989ba55db0cfbe37d72e1d96843ea48833e8344ea9f"
    sha256 cellar: :any_skip_relocation, ventura:       "280e7c0c4b643b7d4d775989ba55db0cfbe37d72e1d96843ea48833e8344ea9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b07ade199b278ee0b6654944dec2e32d9c7791b588b868168b78c3757cddafc2"
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