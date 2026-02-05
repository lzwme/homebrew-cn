class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.3.tar.gz"
  sha256 "d8905e69017556e4579db27c145bbbc71c20c59cf88423e45660d3d4b86c2587"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7bf81fe3748849d6311cdb863652c618b534e4b8bfe96238b8bd76c7f6b2ab4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7bf81fe3748849d6311cdb863652c618b534e4b8bfe96238b8bd76c7f6b2ab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7bf81fe3748849d6311cdb863652c618b534e4b8bfe96238b8bd76c7f6b2ab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "247e178cbae878995bb13c3cbc21378f3a793ffeee893b5262c9d3e045d74918"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9b35b644803efeba9daf5298b479441342e7b72d5b7b2a27096b2c3880d6659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e69bd07753255332da9493589672700b9e797fd95b1e1b21f0df64509355fe6"
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