class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.0.tar.gz"
  sha256 "2e69bf9263de9003d934a40887d45c4ceeef1a7339f0ee61e329dd5fdfae7ab6"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3115ffca86d2c1c09fc4e2eef5142fd99c7f490bdc5cbdd585c5d2529e15ce6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3115ffca86d2c1c09fc4e2eef5142fd99c7f490bdc5cbdd585c5d2529e15ce6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3115ffca86d2c1c09fc4e2eef5142fd99c7f490bdc5cbdd585c5d2529e15ce6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f35ca9173c5d53078a5cb6c06a96ff05c6176ac0758fb0c5fb6bda9e43e075cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "882079f04c7b6fdfcb5acae7f976597ba9b680b81b5eb5221a87287d94a8a26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "499a85f61374d08e7ef6980404b93f4b4afa3b2a6a93d50cd3745e1c2dfd643c"
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

    generate_completions_from_executable(bin/"depot", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end