class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghfast.top/https://github.com/docker/compose/archive/refs/tags/v2.40.1.tar.gz"
  sha256 "1f6a066533f25ae61fac7b196c030d10693b8669f21f3798e738d70cea158853"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfb00d44b39eb8b8a67ae282b9b48dc01a845c2068ac16a7f6132bea581235ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d969f76442da070ec119f08f8d07c51be16bdbc3c26e8be61563e49d87bc4ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1735de92ea4e745d5fe2d334986e0f37a1e475597d3edd0143aed9483684ff47"
    sha256 cellar: :any_skip_relocation, sonoma:        "cadbf06c7ad0f8c6996d16576af2bf2414b324603aa6a1629370d1dc82e4ee90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fd02ccbfd98e7fc8cb598503614c0f5462be442a6203e6d309981c4865732ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01f07b6ee18a9d6f8683154e51e2c242657e36a85a713a537ac0914171ec0b3c"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-compose"
  end

  def caveats
    <<~EOS
      Compose is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    output = shell_output("#{bin}/docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end