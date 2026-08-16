class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.1.tar.gz"
  sha256 "05939796b2f76f26b66c5ad8ef3ccbbbd3a7490969bab339c818adc46ddb0193"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23082f47efb0393d898dc79e4e601d08712dfe2b80c59879869aec422416972e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23082f47efb0393d898dc79e4e601d08712dfe2b80c59879869aec422416972e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23082f47efb0393d898dc79e4e601d08712dfe2b80c59879869aec422416972e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bedfedddf54b629f85dda51132f72def737822a461590ed865be7b2724babe7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d606925ef398c7e6df800f777a2d59fd89563f586bf1fa8227998dc368dd173"
    sha256 cellar: :any,                 x86_64_linux:  "1dc2af82a33f946849c46a94935a343faf8a6e5de51fdb5e3159f96caf27578f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
    assert_match "unknown project ID", output
  end
end