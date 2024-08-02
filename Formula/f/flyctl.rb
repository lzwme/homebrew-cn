class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https:fly.io"
  url "https:github.comsuperflyflyctl.git",
      tag:      "v0.2.104",
      revision: "ef58457177cec822b6c0d4c69c9d9a2b1181d698"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f42154a5a4e8ca66834877e555f785e4211349cc4bcbc6020602e3deb3e3748b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f42154a5a4e8ca66834877e555f785e4211349cc4bcbc6020602e3deb3e3748b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f42154a5a4e8ca66834877e555f785e4211349cc4bcbc6020602e3deb3e3748b"
    sha256 cellar: :any_skip_relocation, sonoma:         "605e1fdc610d62b6180eaee03fdb5f82c6544e6190a15a628cc7bd087a3d06b8"
    sha256 cellar: :any_skip_relocation, ventura:        "605e1fdc610d62b6180eaee03fdb5f82c6544e6190a15a628cc7bd087a3d06b8"
    sha256 cellar: :any_skip_relocation, monterey:       "605e1fdc610d62b6180eaee03fdb5f82c6544e6190a15a628cc7bd087a3d06b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be6b09a9505b7f181570d52965468b696c0a46a8bad84949b16b44b8bb0abbc4"
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