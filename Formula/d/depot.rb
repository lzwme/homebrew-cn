class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.36.tar.gz"
  sha256 "966b5b1936848bf5d05c626cbd5d6b1319f9ea2b0e586ae47f4c6a920cf33ea4"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "483594acb57f90be1bceff9bf324c127e2a1acb8914a13e326732eed839cef52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "483594acb57f90be1bceff9bf324c127e2a1acb8914a13e326732eed839cef52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "483594acb57f90be1bceff9bf324c127e2a1acb8914a13e326732eed839cef52"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ac95621169940e0b8e3c57cd47780359ab679421efe9abb0b1993a24fc4bd67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1163ab91181dc1182c0042ebaa773af4320a61feece6bba32908521d90289e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0e4294dcfde8fe581268f86f706124c8254e06b8593179edf97d27d365c35a7"
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