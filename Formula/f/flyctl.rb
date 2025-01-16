class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.64",
      revision: "962ba636e5d1279fc4da6e1e8eca876eb98ae9c3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a0324f609d6e1473bf00529a484c4fe950e43ff66429ae47af6bc565e59dd2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a0324f609d6e1473bf00529a484c4fe950e43ff66429ae47af6bc565e59dd2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a0324f609d6e1473bf00529a484c4fe950e43ff66429ae47af6bc565e59dd2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "362c7b5ea04e7d418c3c01d679cc78f2bc8aafa3ae17620cf59efbf1a9a0ade3"
    sha256 cellar: :any_skip_relocation, ventura:       "362c7b5ea04e7d418c3c01d679cc78f2bc8aafa3ae17620cf59efbf1a9a0ade3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430ba996b726097c0b878d38410e579d4a84eca10cb8de9fc9506b6ee21c8284"
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