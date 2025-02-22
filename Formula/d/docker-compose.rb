class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.33.1.tar.gz"
  sha256 "6e7365e84041cd696a0ad5542a83df37e3e29524a238e353e3771ae52871ae1f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c2e2927c3591a33ec152ca4efa8c589c445c66680caaed4270c076f0d4b0618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a222be16598df7bbd030376c00c775bd0dcd0a17c28a1ffc3c6dde71af8341"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b76b42b9ed870237a49ba5378667f059e3e7b01a2f7ff75ce331bc8a802c26fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "edef15feac048894cc84d2ebdd819f3aac32bfc09b28e907c839c76316790307"
    sha256 cellar: :any_skip_relocation, ventura:       "fd57d6e6eb45892bcb4205b9a65800bba538263f7734e17d2d6c2b5bbd18d912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a547d2d00cb4d59a3297c7526ec3ba87883996710e48d617ab2b2763c588e8c"
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
    output = shell_output(bin"docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end