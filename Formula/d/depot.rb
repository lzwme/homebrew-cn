class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.66.tar.gz"
  sha256 "b5bf2293af8e19391b12f18ba5dd4ebd4ca703d0fd072bc7812738a257ab59b4"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ada8a3326367ef6f2fdbbb7b4f415d23c6f4f22e1eac8faf8a225cbc9f046c42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ada8a3326367ef6f2fdbbb7b4f415d23c6f4f22e1eac8faf8a225cbc9f046c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ada8a3326367ef6f2fdbbb7b4f415d23c6f4f22e1eac8faf8a225cbc9f046c42"
    sha256 cellar: :any_skip_relocation, sonoma:        "aba2be2f58a04023c26eb522ed7f5d11820fd6dc4d30b3aadf299f8d97b840e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e8b5ef8578e936a495a81dcbc54b21af19b46d6d7a48704b8555808de96fab"
    sha256 cellar: :any,                 x86_64_linux:  "b8774ee08b895d67b1363bb40f0a3704dc4ebd1adfb6f41c5481aa70c50739b7"
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