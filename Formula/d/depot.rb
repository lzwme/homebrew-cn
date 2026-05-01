class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.52.tar.gz"
  sha256 "a71aa79ea0943b43b64346cc4d98e354bef59ad5e5a0de1a176812dd453225da"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8e60b67e96cb067132b91233286a7e5b180f3326a9b0e3db48911119e483743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8e60b67e96cb067132b91233286a7e5b180f3326a9b0e3db48911119e483743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8e60b67e96cb067132b91233286a7e5b180f3326a9b0e3db48911119e483743"
    sha256 cellar: :any_skip_relocation, sonoma:        "61af88981edd51804599c9389eca27eb22511a72cba2a013a4b20cccf7c49df0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa5d2a67f34dd46efeff085699e103e611b51ce09a880415edf4f997b14679b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0667c82357bbc1e43f310b70eeddd2689c9342be2a056dea9a1aaa969ba7a04f"
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