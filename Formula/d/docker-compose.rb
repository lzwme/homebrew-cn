class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.32.3.tar.gz"
  sha256 "d100041dcb4094cb724b6ddb0b0db32db368341ec507c1f9cdf911505521d8a5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a7b97ee8f3f99b00c01e55e387666191bcc0da1844c7ff3239cb056ca309b19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56d0aef1a6d50c5c4208ca2009d88dfaa0eafc032210853f0588b09d5a584478"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bf2fcca713bc0eb48f5408f7f3d97ece6f7f29d8c37a96f7d2524de7c23f34e"
    sha256 cellar: :any_skip_relocation, sonoma:        "185820c67cd51513fe2b2972b81d948204649b81a845c3966a39ac00c7ccd8a5"
    sha256 cellar: :any_skip_relocation, ventura:       "a8b46259e23684d6670e5a3a7d59190ea3f12d5820dafb11d77e16bda1c4eacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c58b3f49772181d718a1271d54ebeedfd6287a45b5437985cc4c17438e6ddb1"
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