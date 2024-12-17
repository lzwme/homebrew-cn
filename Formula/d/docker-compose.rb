class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.32.1.tar.gz"
  sha256 "730a55f6746fdb0b0258ea45d2d9070e6e3a10db901342daa3056f4c4262c50e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d97aafadace14674883d5928c23a5c4235d2900bd3b59d34b57005738127eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c29f97800855e7010b66f0bf38469f831758c22ce19265e9d247b941516f434"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d805d17d08be4272b8bcfacb27764eb9429f310ccbbcb061ba7ef8fc2084c9ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f83ee3e8f7a538fb0a224800857b6ec6604337569916afaee3d6254acc20121"
    sha256 cellar: :any_skip_relocation, ventura:       "217f662b2d0b60f2e8b5db312f0274bc7f67db97e73533a262b2e0704c7e8442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aa02d85746cde52c70825444994cd81e635a6d8d08881e2b961322948acadf6"
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