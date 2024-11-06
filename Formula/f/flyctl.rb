class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.33",
      revision: "75a3fe121bbbf7509e707738682a1fd03c033e01"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dce4283b3f11b4e2014f4752cd5b2368cbcca414883a14bad7f038fb0eb2e5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dce4283b3f11b4e2014f4752cd5b2368cbcca414883a14bad7f038fb0eb2e5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dce4283b3f11b4e2014f4752cd5b2368cbcca414883a14bad7f038fb0eb2e5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a72c295213850ab142e74f6ac92ec2e14ec78561b300f228eea97d25df8a70d"
    sha256 cellar: :any_skip_relocation, ventura:       "8a72c295213850ab142e74f6ac92ec2e14ec78561b300f228eea97d25df8a70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0967d1d819ed70f15795221d34285859fc7b403f2ae135aead8b1f0c916952e"
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