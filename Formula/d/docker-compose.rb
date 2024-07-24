class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.29.1.tar.gz"
  sha256 "9749d621b1b8bc1f5881741e0cbad20b5133a0aeedb9339af06b0187be8141b1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00b00bc15e93bd1c15b22c37a10d1c36e89b1f7f13e31236527c0c119008cce3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41192cf4abcc1822defcf1f9f4df3d8bf7de73fe49545050aef78483d1655ed1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "989f8ef384caf7d2903590eed80c4f064a528603b55b5fc75a33589f97228b16"
    sha256 cellar: :any_skip_relocation, sonoma:         "28b83b8d00e11261f38a40a4b7b086829d826251343b52dfa9a1a87dcb7d6cef"
    sha256 cellar: :any_skip_relocation, ventura:        "5183e11d09080ad784f51063c5642db89a3c355d3036942d08c3e6e817fb8486"
    sha256 cellar: :any_skip_relocation, monterey:       "e6bb89898f897d867894bdf827b623164a332b60b47c16a11ed2c9e09a955ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eb1bfbc7e7495b4a5576f89c98c5ef47e37f8dfa4c56a2ef3a31f530fdc7358"
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