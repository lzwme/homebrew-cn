class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.37.0.tar.gz"
  sha256 "f8d8a613b27e95fb56eef7a8a97c8a63a87d1d6d292837f343bc855c33333772"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a1ea5c53c35773db0f896651a7ad55eead4571d1ca99b3b5321ebbcd94f3191"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f92ac50245dd245e815a360c5ef5aa803389287e2511de7fd66fec4f06a107"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e433967c8bdbf02db2e3d584c6948497192d089cb78755d8e36418aa446c585e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9aa62f0fd0286a0b0c011e6f3babc69da4b58945fa35f1a1ef6f2d2e2ed88d6"
    sha256 cellar: :any_skip_relocation, ventura:       "e8473c91b657c1431e9fbf40cd6f4e0496d0da87c97d85d3248358ce8a69ca4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f0c7515810ffb255fbf82e5c5a7744f8bd8416cd9250bf02e2dd6ed77810a6"
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