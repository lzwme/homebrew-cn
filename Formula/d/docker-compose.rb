class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.36.0.tar.gz"
  sha256 "bbc5de6d0da1c1f20877b6fb3102bf7f4f7ec4882cbc30e9fa9f61908fc9e748"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29cbac67c636fd303d42176136455c324ed52c4ecb9e5ddac00604b2ffac0431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a2742978b20a1fb9f2c75d309ee54b15cfc77c9abb200acdce32c7eefb3ffca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1c7539130b19035663fb6800b02f89e2cc9039186076d625c073928a954d9d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "27095d258e0b2aa3ebf7a458488169a8e8357222f500765fdd3c6477ad301a09"
    sha256 cellar: :any_skip_relocation, ventura:       "01b0ac514c54db5992e259f05bdf9c1afea65e5374983afc33c600ba6981e6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc3f306bb07a40097847f6876264cfefdeea3ef784f4d23c3d066c5168b61a7f"
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