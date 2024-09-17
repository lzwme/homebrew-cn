class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.29.4.tar.gz"
  sha256 "a85bf4b23a52cf14233cc6d8645011e25e5f6a9168e4259de5df0d3386788afa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5337479af9716b63545b762ce49fa8799f72d6d1279fdfd3f74784c1b9920a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9424c46676330e67bb6c4fc068191146ee689aec8a8e1fa7466a30182136534d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98846b5e00ad9a582e68ad79a3bbfc02ed9d274948158d95daffde11e946157b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2e359e1e63c77cc7f76c212b2f149a4347803a8925394aaa4918b108e7fb861"
    sha256 cellar: :any_skip_relocation, ventura:       "47534fe05b436af095e4e6e70220fac8c904d50c74c0e2c1f18e66972f374053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19984c14c5b6125257d0754dbce4c85d8c654599cd73e137825b0ac131428020"
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