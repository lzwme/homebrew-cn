class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.31.0.tar.gz"
  sha256 "2716c31c36860d2cbe5750122894c9bca430afa14a0da9a0a2c4c19a21146bd3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a00122fd6bc3928d38a50f7d761ce8ed6820899373489827f15675e1ad5856d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba559f3ba86df379154c7bee876a185577ebd2a2b9bb5c28bf24300ba389055c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d76225438ad0fe606e32b41ece1e4b791000e4030711f884c021ab83bd336e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a844679af4524a306d4f45203ee80309824438d726913a55139217d739596047"
    sha256 cellar: :any_skip_relocation, ventura:       "d0bdd85f2919aa62d3094e7772e27696d11a48bb33a0ce4c2b237cbb319eb861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b8c5f4b87b6cdddbf870972c7ec85eecef4d87154c226d570cb2944ba20d7c6"
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