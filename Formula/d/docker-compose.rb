class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.29.6.tar.gz"
  sha256 "8ccaca6ad76d8ed9234bc3260190458ed5da6f22c061fde3455ce122664b5554"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d905cc92c2eefa58af707f58aa7b0a5241d4acb749e4c5721de29f885d91454b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6647328d4fe568c06439b10cbfc5c1a6c4bdd35036f2952ccbb436cc62428f77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab51ca5f88ad11ab6d319b1596594567f21c39098cd4cf31e5d5f192d40c6825"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d94556e52d6739be44ccd3abca29089ef9deeb483a56c970406dbc19976deb"
    sha256 cellar: :any_skip_relocation, ventura:       "d35df4fcc78be5e7b148ca332b679426594dc7e5a4f7a2c8cc55a9ca147125f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad3378c1579a401aaa50683ba6aa0fb655a9a57539e6ce784645c8fcfa939c8"
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