class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.33.0.tar.gz"
  sha256 "6543bc9876688d021310df2b910a7f93b5710464660fab9a63e0c6cb1f2ac48d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea4aa03c8623e24c649c7b8ca1099c872bfa81e5b70c7e866cbd74f13456c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57a9e70703bc69330213aa609c7bba546d3f8a739c4a8bdf5f8602e3b6aa137b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51b73a145413dd9d1427f21f9ea5114eb15b6a05bd17e924b71ff02ff63e9d4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c444cbe849f175cedbc07a6037034132b509cc1bdd715c0754ddaa83b8e5eb7"
    sha256 cellar: :any_skip_relocation, ventura:       "36af5f27dbdc15dba95044a54a5290b0ce03f30b0d12c06fc9adb6c4e06ec549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25e11fe4d97cc3dc43b696262e093f03c310190e9b160d7ec03328be7bee86fb"
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