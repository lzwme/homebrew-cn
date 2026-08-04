class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghfast.top/https://github.com/docker/compose/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "142f895ba74715ea0018a20b7f93fa96e36fb6c91ea66f856a61c6e3716c4ef8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "786d4102dccbd2d9eb3180416fcf480c6539866f0e8c6f434ea797819b27960a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5538df00bdbcae30b2685bc582a3c25c0e837aad75cfd049ecb1c2e8e4c55043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15aa78341cd4b0b723657c1ea2976651065b1b8ceea174648a029526b38045d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a8ee0d7601e537619278366cdc83f7e2dab608fc0f2975c09501444190ac1df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "370f421f0f054ae6591203dad73894a489a3f98adea3df6dff0e5b5e9ad5f1ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582ff48efa606748aed6717f7b60bc8fa07bf7f0224d3030cefaabfbd02fd7f4"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

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