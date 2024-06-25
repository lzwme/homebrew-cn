class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.28.1.tar.gz"
  sha256 "856f1b509ef7190fedadec369e290bfb08c2fafb4f858b80a27caf350554fb50"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ff26c006d9eae4fc6ada0cc0f20ed36e33645ed6c6f5503e8b00276a756c110"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a112d315cda2fe91bff1500bba590a273d7916b909f0c4ace4314d598632c538"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07b628e2b308a90520583d79a254b68a3c9c89f24d1aee0270b4f9ec8f1027e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c25d8d9e5b9160a7bd43dcbd427612a3b50cb1beca7dc568fa39b2bb4c84132a"
    sha256 cellar: :any_skip_relocation, ventura:        "ef45f73780dde46c76c436e7aa921cf0744e229e230d8f898a8311bd061274a3"
    sha256 cellar: :any_skip_relocation, monterey:       "8d4b1db8dc5a4fe3fe5ef71c0be61c727144f493416255ec15ed7910934b323c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ae0f9500cb98f2a953f0abfef0bd8e93d8fe3caf0ec9c4e82c115156b87ecf6"
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