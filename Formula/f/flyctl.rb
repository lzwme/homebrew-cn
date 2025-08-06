class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.166",
      revision: "ac15e5c7e48779ae512d8955d9481a0f7834ec7c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14c43338a851db016fbb35e99b1f90aae1fa70e9c6371d6869bb1e89a5c99f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14c43338a851db016fbb35e99b1f90aae1fa70e9c6371d6869bb1e89a5c99f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14c43338a851db016fbb35e99b1f90aae1fa70e9c6371d6869bb1e89a5c99f7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "66de5b1b295b81ae882d2fca508079884fc974b6dbf090a9b2c598518c96903c"
    sha256 cellar: :any_skip_relocation, ventura:       "66de5b1b295b81ae882d2fca508079884fc974b6dbf090a9b2c598518c96903c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a76ef2f180fb958782dbee066bfb9e2323054e8a23559bdc933d3fdc3cd0fae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637ffb686cd3b950a31926a4aeb2ab6ed302053ca66dd91276af81ab9f654509"
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