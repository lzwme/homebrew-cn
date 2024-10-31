class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.30.1.tar.gz"
  sha256 "d7bfa1236dc4bb18129324745ef6c46cc95dc0ba6e9b4ba9ca3bb40786fea066"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "607e51b2668afc7cb33d8eded141f91ae63841b2e8f8ec6ee76293a7a8dd125f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a39a29d19946121a294a6af8bb5f72026aa7ee730d160d6b7080fde7a9d840f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ffebf24c8d9e38b9151c36fc348d280a5e7d291ab458519b487c113960230bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fa08ad0ba242ed536dae7c4f75fbf7850dc0db2639125c84c76c1d1399e028e"
    sha256 cellar: :any_skip_relocation, ventura:       "3c30bace224c4d2e292c55f91e0bc3561d3f1311072125410ee6dc9df1c556fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73fb365d3586ccde72b853a164636fd2cd07f9ff426bbd3e5eb3e45766e4026d"
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