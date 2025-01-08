class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.32.2.tar.gz"
  sha256 "5bad84c26e31c790a2f09968bac6f57ed2d23c3f12b723a132fa854d4f8f5537"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c394d228afb22e6a20052c299a36e031ff0b2a3a144b1d0477c408d4a2acae55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c386a9d0f22b84a7e92e42ddb22d11928cd1d4de4a86afab7e520ff4a005da7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "280cd302f0f7a1c1eecfc078b3eb7b63904565b06c38d88fad84f944fc0e6165"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f17bc14f0bb8b368434f46fb8c9d1d9a46a07ec823348c9e4020d1ad2e83a7"
    sha256 cellar: :any_skip_relocation, ventura:       "dd0a4d0b8d7f7ce8f27bf1beea8fd9c175d8239f8e298339551f0fb6b65bbed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f413960613acee6de070dae16192d5efdca1d43a7df4dfb4d0ce840e304f5a1"
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