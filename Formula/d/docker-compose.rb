class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghfast.top/https://github.com/docker/compose/archive/refs/tags/v5.6.0.tar.gz"
  sha256 "51ad60cc28d38a0850678053f0a259dfee931d150dd1d50ee9e6d758125b1d47"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70d879817d7ed5c4eeee7fa4ec757ec1adbc092068b099a738dfa27ab49a3857"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7bd222c5b72ae1e35b0f330083ce3541e1bc3b4256f87eb546f75a5293ea77c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0c45f7c6b7a1d21ac71732c6bb680a90dea7553184833a63f982af19366dc95"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64e0ca10e635e5832677f707091bd03d69bd21a5b6762e22146b53e7acd50dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f7e79e30510057735d6acd4d9707cf1ef2f2b0b493160d9a9241a6dc56929c21"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-X github.com/docker/compose/v#{version.major}/internal.Version=#{version}]
    tags = %w[fsnotify] if OS.mac?
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd"

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
    assert_match version.to_s, shell_output("#{bin}/docker-compose version")
  end
end