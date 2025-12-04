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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "400aafadab847faf30e287194dda351313b109573d02fe56d0cdbe2078271375"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a75c7301ddf479d13cb4c9df0fc6867b6985ffa9c6fc7c9941e4975631ab660e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45bd444e96b25bc62cb7b46721c6feb578cd9e0a8fe0ee24bd273cfa566bbb1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "78392813c8da161f21af93be917f9bb7fe1ae4b826a71f16990a7aa44760ecda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e86d832c6af45571593ac30a4fb33b1d198f0422adaa36c6abbc29977c0b522f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df56d8cad29bb32dc871eb4a9b1cd1de1a02e0c4eed4bdefbccb3b4b1aa29a07"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v#{version.major}/internal.Version=#{version}
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
    assert_match version.to_s, shell_output("#{bin}/docker-compose version")
  end
end