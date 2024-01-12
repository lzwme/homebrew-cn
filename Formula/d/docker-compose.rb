class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.24.0.tar.gz"
  sha256 "4ceafedf732f9203ccc85f6ec5fff68bae992700339905b0c51ede5b73ebbf45"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68d2f63ebe03a1d80dc15ec61215c2e810f157d5f1729da3fef46e303b06f8bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "836156bb7a55bbe092719064e63838572077ebe1290f1c25f5375853aefc2a60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5f5eba975da4e729fe8020b134661a83a12fa9447f767823a01b5783e652d14"
    sha256 cellar: :any_skip_relocation, sonoma:         "23972cdf4c66895a1b0a6ea53042cceee0173f388cffa375f37f8a6f12d8dc44"
    sha256 cellar: :any_skip_relocation, ventura:        "466c6ca3419140d8e4720a8e81187e4eadc573eefd03c3cc760ffaed67fbc6c2"
    sha256 cellar: :any_skip_relocation, monterey:       "6cee7ac5c6cd010e4b52197708dcdde6edd680ffd649b197c6b1dfe4c37324e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f885a49dc715462df1bd3a5f2b702a1e4461a8b0b7a731e916d8268959a08c6a"
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