class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.30.2.tar.gz"
  sha256 "ef5e2de92672a4de8d9d30111c15f99765a52f121bbe6dcfe26388e82a108e61"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b134f4f9026a8f913e19851687447a3f628f9ad43cca5f5272c902b93a30b0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8798adc92f88108fc1379f336b9a2a3c8a6b94a2ff494adecbf1fe3c7d02e0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3795a3d9719c4aac2d4bf2f896d6f4aa9a895099da6800e3ed1d20b109e7e3b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "df953ab17419e259315d86644c705563447ba6f3d4f84298369a11798e1b11b4"
    sha256 cellar: :any_skip_relocation, ventura:       "f37558326eac5b86b4713e4b1d8417498bbfbfc493a128a9e2dbde3d91ce5f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f96a769d02533ea9442647353660d4b7defcf83226b0baafca217076b2066d9c"
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