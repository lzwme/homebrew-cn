class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghproxy.com/https://github.com/docker/compose/archive/v2.20.0.tar.gz"
  sha256 "983b372bfedfa832699fa18b6b9dc559ea42b3f0a97eff5d5f4f3994954993fe"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbaf2a4701696d4bbcd90074d7a8e62e203bf9bce72541ccecc8a8e0fafcdb55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52f0e00f2c5651b8f7b58caec291ac9428c80d9b90b817608782360bbbd3df8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4deae0450f8204ad68c3588632ea18b28194817075819c83a743f7c961f212b4"
    sha256 cellar: :any_skip_relocation, ventura:        "677a800c524d133cc727334ba316365f59a8b2691cd7de81f915955fe4a772eb"
    sha256 cellar: :any_skip_relocation, monterey:       "3dc898a6093d3ba4eb45be7bffe528dd6a937440414975d7c7a01b002c103548"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e7b2df1c959472454e6c239265e8e3b60f82b86bd48335c4eee2c2aa5c03ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc7c0eba81e106f8830be5cc9e01905acdae009cdb0dee4592c21d2fbbcef0a4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  def caveats
    <<~EOS
      Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-compose ~/.docker/cli-plugins/docker-compose
    EOS
  end

  test do
    output = shell_output(bin/"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end