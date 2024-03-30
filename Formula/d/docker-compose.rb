class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.26.1.tar.gz"
  sha256 "081ad40241f8e144cad088a65e6fd0ec588e3d36931e5baabb3dc5ab068ceb60"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d88c95048e54a0db47dee71dbe152b8d83db4fd16d5c1ddecec989d514459b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "015bca6715aa11148e7916292bb087a655391c5d0b0e513a93d0dfe0ec877d77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42c13eade2a9fdaab676a3475aef9bf6255c7d9e4418ea9455baa2ba3973bba4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0bac960f3af4af33af1bc4e4ed3c4b55d7a0be5873cec64cd3a2c9fdfcf0aaa"
    sha256 cellar: :any_skip_relocation, ventura:        "56dbb52e0f9162275e32759c820a07c49fbe5f826da0471d4c243dcb2aed5b7e"
    sha256 cellar: :any_skip_relocation, monterey:       "a505636baa78eb1a1eef7a2783cd4dd4803a1d1d8d36e70416682f1d5119a50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8c4b16b666544f5ccf7cb06617cd5db92d42d96274c520bf5441a7d3e188e16"
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