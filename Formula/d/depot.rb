class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.101.39.tar.gz"
  sha256 "7196babf9f02b9a4aea5fbdd48f54bbd6e759bd5874be648ffc06b6417cc8da9"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a83f0f564bdd6f7231c7892d328fe847412fac63f6a5e8d9e66bf0e07d4ee259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a83f0f564bdd6f7231c7892d328fe847412fac63f6a5e8d9e66bf0e07d4ee259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83f0f564bdd6f7231c7892d328fe847412fac63f6a5e8d9e66bf0e07d4ee259"
    sha256 cellar: :any_skip_relocation, sonoma:        "133c3ff6150a38a55cae9ebebd42df1bec4e7e42e845d4db059b82287f4ac055"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae9c5630d593f1e43dd69f9f5cf336a727de8a9ec6e91108bc09b87f1cb91875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e31d5a0fafc7fc5f7f8ccbe84055fa2c7319c33949b4cb10ca8ba15b37991d64"
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