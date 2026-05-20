class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.63.tar.gz"
  sha256 "1063cacf05eb3ec1739484254ddb6a63ae06c5bcf70e01078b55c6a310cfb694"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50626b3851fb68dffbac33869be57366fe8c6cb92dd3ab6199a5d0c2364fe9d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50626b3851fb68dffbac33869be57366fe8c6cb92dd3ab6199a5d0c2364fe9d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50626b3851fb68dffbac33869be57366fe8c6cb92dd3ab6199a5d0c2364fe9d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b937673a04529636cbf8efe96ce91a06de033797d8ef43f009b3c9180c86a91e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f302b663c7788a14088f5b19b29b9ce18c912579bc61c0fa16d62260f074a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5f2fddfa9505820225814bc18607955ed2b532a0a045e90d42e10703603c32d"
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