class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.156",
      revision: "3d3460f72b17947fedb048d048515e3d3bd25e4b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53bf33d839af98b3a15f6fe5ed903ce3d11f012589b0aa5fb58c0810f835d7cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53bf33d839af98b3a15f6fe5ed903ce3d11f012589b0aa5fb58c0810f835d7cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53bf33d839af98b3a15f6fe5ed903ce3d11f012589b0aa5fb58c0810f835d7cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "93433506dfd943871a4a31bfc765b3fe90555b2321bd6d2ad81f9af838332f54"
    sha256 cellar: :any_skip_relocation, ventura:       "93433506dfd943871a4a31bfc765b3fe90555b2321bd6d2ad81f9af838332f54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3c4a0123cd8c6f31f4927a884f480059e2d078028b02530b4f91b81a337747e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77a15945d86cdc956d635b16bf2d74c8f39893ac00beb4e5342dd310391a5c9d"
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