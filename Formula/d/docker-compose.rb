class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.24.3.tar.gz"
  sha256 "255b6e204c87a0d13e9f28cc3e60c39ce81c879a6df5d14d3202fff159f467db"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d0c85267baaac148dc9cb56d1042ee36d6b4330c2f95f681b638e1a9ad5b68d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be14e099922c48b17cea7c6bbf8d8dcc2ca1f7993ca9fdee1abb22e16ceb8cbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58dc4229c7cd096d6fa6f0d9957be0f91f6cd136eecac42e5eabfd89465e9f8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc93d70b64b77b0f4b5d1b5170450655c55c3f7da2bb2bfc4458cb5fdea463c8"
    sha256 cellar: :any_skip_relocation, ventura:        "25dac205edd14c6270b4629654fa40b421e502954b51f3bb67b299f38e099e64"
    sha256 cellar: :any_skip_relocation, monterey:       "2569f1e7fcb4eb6513c8e37b2d0a4e2ea40dad402d567cb51162f683ffff465b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "897c76b48c962e4b2d30007dcf3f1c6bae9dadeb7b4eaeca11af38c208b18360"
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