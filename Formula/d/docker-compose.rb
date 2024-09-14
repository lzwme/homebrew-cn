class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.29.3.tar.gz"
  sha256 "55ddbcb65bccfc4f4ac4a45930eab2d1ee8f45ceea3988b68cd25982d688c9df"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ff53aed5515781221a8fe42489de7808ecfd8468c446bdac1236997100c30f49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8827e5c49364233477e63fdf8ec00e6fc9b7544d5e6c343ebb3d8bc55ad05e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8886691ac4e0669a26b2099da1fc00cdb439c64a6511135c7b1d1d2b1080136a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5908d539b2fb7129a042428c2c26bb8974a3ce27d59ef4bcc3365f8ce49fa6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5902116f6091b1d948eada9d8f11db5d9e6c8161492df0365f599a7bb4b196e5"
    sha256 cellar: :any_skip_relocation, ventura:        "c2450e1613f1794820acfe94fb10dc34da6510aaa0037bef79f3722b94ac4c63"
    sha256 cellar: :any_skip_relocation, monterey:       "4dc9bb8001cc729c061e955b8b886f096ca943ef6c99eec3760e24ede6976a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7103cb245489aab56326eaf587ab02b65a0ed3940abc3c2f5cbcc26d27cdbe9"
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