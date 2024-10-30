class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.30.0.tar.gz"
  sha256 "f2bfce36128a14862192162dfd03bb1f4a493c0cb09ebe9b13105b2e12e4a088"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95feeda6e9a8fae4d8ad137a96886703717dc46088f579bdf367dd10c8433099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f5db29ff449c743181cb44966b5d9e8cf3de21bf1de9311e40663e07e7c7ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c155dc1eb85ab081ccb4d5c06db5ed08cc968379a603189e9c570cf4ec95e5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "154bdd412d07c1b298b9f59659399f01b2b482ca471020edbd2ae98964c56ad1"
    sha256 cellar: :any_skip_relocation, ventura:       "03d4cf8761d313f172586e549594eda02d830f5629edee63649d23787711c3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1894835722bdfc606699ab933bd9bdd5be8e2ef21f27d877e2186925e2f158c"
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