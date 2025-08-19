class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.171",
      revision: "41691d428650e68060b159d64e0d24e99fbeca6c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4c1d62954467b607625bc6a04a53929ecd2ef29a29077b8ce2cf6db55a01656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4c1d62954467b607625bc6a04a53929ecd2ef29a29077b8ce2cf6db55a01656"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4c1d62954467b607625bc6a04a53929ecd2ef29a29077b8ce2cf6db55a01656"
    sha256 cellar: :any_skip_relocation, sonoma:        "a08869ead503efa15bc3a78085557e302078dae9f5402aca175b28ceedbfe92b"
    sha256 cellar: :any_skip_relocation, ventura:       "a08869ead503efa15bc3a78085557e302078dae9f5402aca175b28ceedbfe92b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52ddfa73b7c704c66b4c145ac5c1041af6912a6481a4a5f2e7376fe13b8af656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8742370ac81ede3cce9fe476428faa0616b3d8c05825febdf8f0bfe6f5cc9dc5"
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