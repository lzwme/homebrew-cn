class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.118",
      revision: "a802b4b75b17a76fbb00c02234d9253f0245797e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a30385e1f059d852ab75e85d321b4451c26821cd93d4ec02f7b1ba1e4cb5832"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a30385e1f059d852ab75e85d321b4451c26821cd93d4ec02f7b1ba1e4cb5832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a30385e1f059d852ab75e85d321b4451c26821cd93d4ec02f7b1ba1e4cb5832"
    sha256 cellar: :any_skip_relocation, sonoma:         "8644d3bc0df6b013139c1bad46f77c473d98cbddf7de6d336f778bcb80257c44"
    sha256 cellar: :any_skip_relocation, ventura:        "8644d3bc0df6b013139c1bad46f77c473d98cbddf7de6d336f778bcb80257c44"
    sha256 cellar: :any_skip_relocation, monterey:       "8644d3bc0df6b013139c1bad46f77c473d98cbddf7de6d336f778bcb80257c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52fafb96054c0e9a9bb4c3d1441ba14270a21b13171e43c7110ea50276f8ad02"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end