class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.36.1.tar.gz"
  sha256 "1293a16d38c6d072327efe77482a4d47b371463d1f18529acec27fc7833f0574"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "793858dac3e9a5dcf4610501bf952088e91d0edc1fd20ed4b812ff0068feb5c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ab38e91850d0a31e461ccb0beaa4e6199d208dbbe3a043ddd0f6172c41068d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d4ef3dbcb6f2b676b44387a17ba719d7052c56c54b83baa648446f2918a0125"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d6d06280bc48a2c520484a350a7585fb09b181b3db93400fd07d264999146ff"
    sha256 cellar: :any_skip_relocation, ventura:       "339bd4efc6e8953b35c3a3c8501333a675d08361d82e8c56fac655a21f5bd4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1ee75f35e5fbfd6231f7bce00f86735ee7ee9dae50873c2b3fdfa95857a9d4"
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