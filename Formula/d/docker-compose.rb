class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghfast.top/https://github.com/docker/compose/archive/refs/tags/v2.38.1.tar.gz"
  sha256 "874fda5c816726c442eadebcbc9c08af6b1f980a949d92ac42a16bd9bd2d3d24"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "168aee92d79f9cbe91e2d76d5d4e684d3b72407f2cecdaf5ba03d4d2028263f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5c6c82169652459f7ca8081d8061b1cd2237d437a9a05feab3ae130c450dc95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97de23c7b48873c3d526615874b0082e8c9f8492537f27ae77894d29c6e595e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed0ab40f7ba886680a2aee72b455a4e30d877a7546e3502b2e2f73c7247e3f70"
    sha256 cellar: :any_skip_relocation, ventura:       "3a7f5d8e7f066b562d5f9582b43a7fee16da8b757ef6c13009df911dc273497d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30264521a108288d59a626f2bff45ec5eb65d043b018efeadda6d44e241666d6"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

  def install
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
    output = shell_output(bin/"docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end