class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.37.1.tar.gz"
  sha256 "63fc8a368a900bbba654ca0411cf4d875a3fedcb6a5d89aa8e817495e927a493"
  license "Apache-2.0"
  head "https:github.comdockercompose.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9344d9dcc58b72e422e4fcc5a880c1e3def26322ad5b88c5da28475b1724669"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca640ba682284de81dd6e9b5d3357b870e0cb260bf73be632d17b4024cd8de4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "686239c1a310f15d6f6edd50ee3d2b75378a6a49f305546c482046843ffec284"
    sha256 cellar: :any_skip_relocation, sonoma:        "47746b2e6ed7471b5f14abb99530c9dad9eb337219027909ad5efcf0e9fa448b"
    sha256 cellar: :any_skip_relocation, ventura:       "73c0e0431f00d304b0f78af5af4c2d3891910a3b7c2fc839ce63678fde7dc7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e11887527a77ebd5a977affeb69a9cec7effb76b4c5744379c85ce80dc5dc14"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

  def install
    ldflags = %W[
      -s -w
      -X github.comdockercomposev2internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmd"

    (lib"dockercli-plugins").install_symlink bin"docker-compose"
  end

  def caveats
    <<~EOS
      Compose is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~.dockerconfig.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}libdockercli-plugins"
        ]
    EOS
  end

  test do
    output = shell_output(bin"docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end