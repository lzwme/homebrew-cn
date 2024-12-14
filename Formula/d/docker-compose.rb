class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.32.0.tar.gz"
  sha256 "9a128c281641090d413f89da1cc3546ae936766dd18489076315348f2c103636"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cfde1a9ff0954655268c4799b33d6b3777cdc99ffad953befa73f1da39157dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02bc3f2d8b56bf963f5b9ad4b6a5e3a7db1b0bd33cf65eacb519c487cb6b3cad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b20a12ba46c9ee15523308034f48151e9326389c94abc2241e337e159c17f4ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "984ada417208b592e670352c3a54f7ae0fcbb50ddd63b0d060a6887bb75cb91e"
    sha256 cellar: :any_skip_relocation, ventura:       "c9184c996b61d31f989f985af17bb99a2678c09c6f380205f94c8f6564b414cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81696303a0c3527b55b6a4f53b703322aa856743c7d9122317cbac3c148a2be4"
  end

  depends_on "go" => :build

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
    output = shell_output(bin"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end