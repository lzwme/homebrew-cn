class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.168",
      revision: "f95a017e0758cec4cbcb7d0f3fb776db2db144ad"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "821e970500ec6ffd12d00424187cadafecfacb527eacbf1dbb9c2f5d990f6070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "821e970500ec6ffd12d00424187cadafecfacb527eacbf1dbb9c2f5d990f6070"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "821e970500ec6ffd12d00424187cadafecfacb527eacbf1dbb9c2f5d990f6070"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0899250d1eab79bcdf72ae2ae6a5a18871cca8765a0dac75277f7172fef2673"
    sha256 cellar: :any_skip_relocation, ventura:       "b0899250d1eab79bcdf72ae2ae6a5a18871cca8765a0dac75277f7172fef2673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f34bd0d155d23aa4934573e45a438a2da6d2952b5c558ad91c57d031659389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f26221d23d1249f1f55a2be23eec14fb172ded00406a2fad20d518205a4e3c1b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end