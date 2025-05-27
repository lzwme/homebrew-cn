class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.3.131",
      revision: "80530e100d33f77a3da7584ea74a22554882d7e6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "040da7034558a166d27cce05107d6a9796e7a10dc5b88d9b31e9fd6fda01d107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "040da7034558a166d27cce05107d6a9796e7a10dc5b88d9b31e9fd6fda01d107"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "040da7034558a166d27cce05107d6a9796e7a10dc5b88d9b31e9fd6fda01d107"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a33a5c1b7f8a69c21100503220b01df87bef8ef1d0ca6a892e55b7391b865c"
    sha256 cellar: :any_skip_relocation, ventura:       "91a33a5c1b7f8a69c21100503220b01df87bef8ef1d0ca6a892e55b7391b865c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "733fbcec247486ab45bf9f72fb19ae977ea78aae2917c319bc2fe1251e27f848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b9d3377708f4c72b8971ace21b738317f91e152496a1b493cf30f49013adc8f"
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