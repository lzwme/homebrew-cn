class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.24.2.tar.gz"
  sha256 "0929b693437da762763d2959cf5050ff00af627e460fcc5bdb990589a0be1933"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3510f2173abafa69562adf7f326291f694e31bd3ee42287aa764f3f22402d538"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f9ccdb72b6451e1b1ad1cea46c79cd22c4870e7a6afe5a2ab4817f333f52070"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b9e699ad98c093562bb890e60882854e8d967438924ab6b396fc6c1aef2d214"
    sha256 cellar: :any_skip_relocation, sonoma:         "c159b38586a0a3ea1b224f4270cff5ba39e2ac06a12677483a09cf8671766bd9"
    sha256 cellar: :any_skip_relocation, ventura:        "8766a6c20bae1d4f92c7fa80791c925a5049f711ddc95b3fc04792cada5b703b"
    sha256 cellar: :any_skip_relocation, monterey:       "ed9d1f86a2d3f74d8113f2124347eabde7fff63dc3bac099ca6ef9b26045c317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "407e526bcea6d5c793e922254c39438c941e3a5ebe0adba5dc0b6a5a394f64df"
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