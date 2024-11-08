class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.30.3.tar.gz"
  sha256 "b9b6f45ccad892a3f9353a03b6bdf3f79ea15ee2076f98bf013ef1db40034378"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8998e922e61ba74b3785eeb9c39a321245299e78142eb2dac175ac4f55f2975c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "511309143eb081d779d710d41260002a92b873e260609bbcc2318f95516f394d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19ce7beff8f8d3b175adcb055a21bcd0bf205c7a086996e01bf3d362db377e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "99214f5d88636f68b3493292c24eb187833baf02bcf4ddc0005dcffa986d0532"
    sha256 cellar: :any_skip_relocation, ventura:       "e4eb0846aadcad6a5b182f26980e4cc117ebf3ff9708c4ac8b894d6a074ac020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "effc47ebf7cc761528a85901c75846816a3a667eb098aac5ed7aae17491e2070"
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