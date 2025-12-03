class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghfast.top/https://github.com/docker/compose/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "2c50b805cbb35c7257b54e739aa71c5d7aa5da3a8b2da5c5bb8f145c3bf02e96"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3461b24308b00086a27784122de17f8459423bdbeb34061e0f18e8156538d66c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eca1cf05a6a23cc1586657be72fce7fca9f655bd99e3fd8b99aa7a4f0b8d013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39eb34ac0326bda8848a7f17ec554059442c0b99c4ec6c7ec7ca862b3166a037"
    sha256 cellar: :any_skip_relocation, sonoma:        "831e6920d566f8fd9ea93c883f5fc1fee34faae396cc25a83bedca2aa257f38f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773c09ea3933d51c4359d6a2953d42d655e28343a5faf3e6af492ef910778566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5800e53d4a555fdcb86bc26c5d446a6938b60e89c73ff39613b01895b9c33aa5"
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