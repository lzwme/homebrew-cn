class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.37.2.tar.gz"
  sha256 "80b8f8087ade39b74452ad4d8b3a9f2b1feb8139f10c7c3743ccff2dc1fd9240"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb8218af5dc43b91cca9489b5833958f6a086355b475dc40319264953d60e320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aba630f43a492eed705559d0210fa31a876a861adc3a7a3692e731fc0e2ea2f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a5b7d4b0f53bc4fbe06bd5b49d95dd33b99b84aca05c7974b2c9bb1e745f407"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2151718ce55c6a3a0be422e214974073d21884ceaa5d74b99ccb2aaada596dc"
    sha256 cellar: :any_skip_relocation, ventura:       "342e98a97fe4e639beffe0f330ae4a5f2f6073026025cdaafcfaaef74ec9c241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da14c795ea2496f5efca094630cec0444a4eac25bf164c43b5e9a64936b74a17"
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