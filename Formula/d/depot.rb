class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.25.tar.gz"
  sha256 "9a028088aa9fbb1800b22e09f6280b4bc9d1603fe84f003059b853d90bf526d4"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f799e5758ba94df1fd7c8dc8d6377413cc2a988a201ee97140af8208505dea01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f799e5758ba94df1fd7c8dc8d6377413cc2a988a201ee97140af8208505dea01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f799e5758ba94df1fd7c8dc8d6377413cc2a988a201ee97140af8208505dea01"
    sha256 cellar: :any_skip_relocation, sonoma:        "32daef45d3d19886df232a92d2b74860afccd9639012667cd9e1348814417a48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f09f242de12acb648195b82883cb10dda5cea4fc1b3b0e7a92819dde85794dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06aae5c0dbc330c25122911187089c5a414b6e1e83e61f21a176cc0a876c4a87"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end