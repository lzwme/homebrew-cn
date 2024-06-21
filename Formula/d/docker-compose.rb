class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.27.2.tar.gz"
  sha256 "1769596433f68fa68ed67974e796ddb71a96064f18e0d79f5c4259ed5c1be98b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c611be41d3f0e06bc1dd0fb4c9801315e13997ac7f1b573c4cc2b907672f4521"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "051446f070c93f91fdfed2b663988e6c8bc70e62b2bff48c43aefd73540db9fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9663c4bbc502406018678a29245f778d804a39c2208f8170b352c263621e64e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ed69af53c6b36e85c8cac7fd319e7b6de7692b277f1aa354920c262202fce6c"
    sha256 cellar: :any_skip_relocation, ventura:        "4758215626f224ceb11259c0ca0a3a64fdc84faaee83fe84d862766ade9c829f"
    sha256 cellar: :any_skip_relocation, monterey:       "3cf07582a6ce6a566ce39a97011724b57d379ccadec756318bba18bb1ad51c24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f47efc93ca7697b84f856081eac62a6eed687eeb212b38e74f833a46351073"
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