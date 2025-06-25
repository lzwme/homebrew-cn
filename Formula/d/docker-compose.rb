class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.37.3.tar.gz"
  sha256 "b5b21d1886f41cdefe6f4f089503047b60c3f66322b7130636b54f5ccf374441"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ad79e70ad2b2a8aad8dfe8a8722e7c68fe58c013186052c51b23f0dfc9fc782"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd8db594aa93d68785ba7be5b90b3052543d66cce83e4f4acaf34349afdc469b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "979d9caa0b3ee4a421207e236c759da8450e2aec47b06ef47e0643ee088a0306"
    sha256 cellar: :any_skip_relocation, sonoma:        "479bc1f480bb19a622c198b9fd880d5696f950cbb4538eb01c8996653091aee8"
    sha256 cellar: :any_skip_relocation, ventura:       "9f453e24c5b38743604b7c6d403f8f89af261ce2acd0791b03b95fbce66d1710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02077f8dd442c610713fa293c714d4dff93b1cbfc80329364a2476849fb8cbed"
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