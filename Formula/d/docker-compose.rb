class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghfast.top/https://github.com/docker/compose/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "61ffbd8e8461dfebbb1c2e195f96b372a5bbc9343e6c1ba01184c3d630150a78"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6864064046b61f4c5d435d841f7d9a91ac7f3f91551e346b4db1e199c5e023d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bed1261e46cae62e8b59370060daf8b3a80c6eed3e01bc42a0daf7777a42e4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30576dba80d35513e234b9e6394a786a52aae2083705078986f52e489f948048"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3a71f6010b9488df25a4665e994459776adb9897e8b8c339bc0054b9e8c0680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c90960ff25d218712d94abd68ed270436b88bf527df5b97ceb092f7a31f3c5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22f17f70af94a2d01755dccf3d7b1f01f038a105e71311fc0bb308364a4ac404"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v#{version.major}/internal.Version=#{version}
    ]
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