class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.29.0.tar.gz"
  sha256 "0e34f4822e6e1076e94cff203b50c0f4a624b7a2673531ec97b04d5859c9dac2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "643736fd741b46f61b7705a1bfee62df4ffeace505290ed6987d0015707e7d17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5c88de7286bd36d251f8eae6abdd0e8a4b7bed60bd149773046f439c17c0634"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "063e18e874c8a885c77d1d338b585378cd5cda170dce61bffe4c5d2ea997a19f"
    sha256 cellar: :any_skip_relocation, sonoma:         "23209742aaf535b9e3721754ccb02549e3448893e82506304f0d859df59cf200"
    sha256 cellar: :any_skip_relocation, ventura:        "6c0df3c156fb9ddccdc3e45b9d58aaec8ad464d6f5b30ee014b7ea8439fc9e6d"
    sha256 cellar: :any_skip_relocation, monterey:       "60871a4d62b770ae9e42580dabf84d5b97c42089ca6eb2a656ac8547096adac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d247530b31ad64ab696e7753c3336e2df031cb39db247fed081fedb93b02f52"
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