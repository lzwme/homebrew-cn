class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.28.0.tar.gz"
  sha256 "752a6c95d077126d6c459150f1db8111d2b7d01fa7495667dced07d8e3e8ef31"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41603dc9b2dbc0fa25083aeac46c067bd71fdf2e4fcac7d4a6107e82ae307034"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df6b7dcd019a49ca7d424574bcaa3187f4db7f339570fc237e38a0929631d0cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32aa8c17fbcb178f44ef8e3f6ead75d3979e6c198e40ca96b1ac0e484bce0de4"
    sha256 cellar: :any_skip_relocation, sonoma:         "73dfd63eccaa083fac9f66e598d34d19a7fc93157ee106cc6581d959e5cca426"
    sha256 cellar: :any_skip_relocation, ventura:        "940ac20a537c6c3a0360a6da112bdc728347e2e356e047b6e79eb78b05ee2525"
    sha256 cellar: :any_skip_relocation, monterey:       "9cbd2ae2a71a2c46d712e51e956b5fe3e9e20bb6c9abe6848b362c6efd2aa62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7ac0c604f6594a30f5acf31bf93ba5240fe18df9862938cb79071f20b88744f"
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