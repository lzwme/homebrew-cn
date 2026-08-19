class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://ghfast.top/https://github.com/depot/cli/archive/refs/tags/v2.102.2.tar.gz"
  sha256 "4df1ee17af91227db873a64901ab4ce2364a2a4852ad1a28c15ec56c2e43ad15"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1116ab4551839ce5d706e42abcc4a98c88258eb7de79706739020a5690ce3ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1116ab4551839ce5d706e42abcc4a98c88258eb7de79706739020a5690ce3ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1116ab4551839ce5d706e42abcc4a98c88258eb7de79706739020a5690ce3ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4473a8fa3c00a6081f1f6c9328e5b3bbb5edf7e9ca65e671aca23479cbc6ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ea75cc7c1178b32f21b943dcc712fc2eccf32360eebe94bcda7ba44b43062ad"
    sha256 cellar: :any,                 x86_64_linux:  "a4a764fb4022b33201430334f0a5669fd7c52d8e94ce56af3013327e783f848e"
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