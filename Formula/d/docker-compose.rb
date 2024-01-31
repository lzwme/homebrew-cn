class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.24.5.tar.gz"
  sha256 "160c575658cdd65836ea3138bb6337f75877df6cbad8e2d4bf4ddcf850cee382"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bc016abf6d75202e44fd9b877f36e7779d5e431ec0e72b28e29be55aebb6398"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46ab6f56ae915136838ade2907b7156e9d826fa8ce8355393af1a43d67d73d12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aea1f5fa4abf0a67fbc47b9e736900348b5fe0a31a0c05e12473bdfa1115bad"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1614b0dc392ab71b3fe6971d9310b4e9175f545962c501bc4d8e976f8cbeed8"
    sha256 cellar: :any_skip_relocation, ventura:        "6b18f7a34393bcc19fc140595e5ffa64a376292ae257b5a8289cdf7dc0ef3a57"
    sha256 cellar: :any_skip_relocation, monterey:       "9b0cb7595882ac776e6e8dfcbbd3622b70fa9c9eb29a9e72bec0454d478c480e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c97621c551fb36a97ba6161882d265d9a9a45110a077c0c589a2f587be4bb3cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdockercomposev2internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmd"
  end

  def caveats
    <<~EOS
      Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~.dockercli-plugins
        ln -sfn #{opt_bin}docker-compose ~.dockercli-pluginsdocker-compose
    EOS
  end

  test do
    output = shell_output(bin"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end