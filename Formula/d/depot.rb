class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.32.tar.gz"
  sha256 "cfd3ecf4d62edadb5e6a2481d278cb55728e8d543402844e91ba1a3b1a14bcdf"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b282a00f10a6a3114bc9ef6888b73c18ccff414dacb926a5843c707f22468480"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b282a00f10a6a3114bc9ef6888b73c18ccff414dacb926a5843c707f22468480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b282a00f10a6a3114bc9ef6888b73c18ccff414dacb926a5843c707f22468480"
    sha256 cellar: :any_skip_relocation, sonoma:        "8492a7f20700ddddb631c5e87631bf848b1ac684f92470d913158ed3741c93b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2fb9e6214dc3c2eafdbf6f586dc17fde73ebaca5221df601e487b28bae752ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae24025a8fdec17bcb2dec6d30a65d22b6bbfb36802ae4e2bfb8c26d469453b2"
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