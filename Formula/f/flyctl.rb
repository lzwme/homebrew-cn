class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.6",
      revision: "9ecc14954bda369960c94ea966597c533275b296"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8af3f33b209a49baaca99eae84e8936f8281b46a881c4a3024b6404a7ff28f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8af3f33b209a49baaca99eae84e8936f8281b46a881c4a3024b6404a7ff28f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8af3f33b209a49baaca99eae84e8936f8281b46a881c4a3024b6404a7ff28f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf93c21a9e00199acff47c8f626a2461927e4974314b2a3c28d02b403e2f4f02"
    sha256 cellar: :any_skip_relocation, ventura:       "bf93c21a9e00199acff47c8f626a2461927e4974314b2a3c28d02b403e2f4f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a028f542511732f32504ec1faa386dbd9a2daee57863eea89f5201a59336e27"
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