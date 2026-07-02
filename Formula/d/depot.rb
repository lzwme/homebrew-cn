class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.67.tar.gz"
  sha256 "cd04a967ca93074879f38199a8eab9c52b29bc9344705622dd48afa9aa1a4eb6"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a83cf6201895eadda6071a72298969eaac0b443651acbf0295a1ee1b4758fa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a83cf6201895eadda6071a72298969eaac0b443651acbf0295a1ee1b4758fa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a83cf6201895eadda6071a72298969eaac0b443651acbf0295a1ee1b4758fa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "358df5e44259d502b442bf5879583541ff0923b45dc25f1bbc07785d433f2616"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9934fffadaddac34a676e184e0d88a7822a38555c4f3e91aa145992718c24be"
    sha256 cellar: :any,                 x86_64_linux:  "cac2b2425490b497bbae2beab3d6323044a2fc54f038ef5ff8943a2eb64f9fc2"
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