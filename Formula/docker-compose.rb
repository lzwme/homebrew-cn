class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghproxy.com/https://github.com/docker/compose/archive/v2.19.1.tar.gz"
  sha256 "869d4ffd3f6b6835dcbb5cd627e98a9d2f1d30a9ae2c8e712275db9aa3e6e97d"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0730b93790e81a2e4adbacee6f3d22a2cc0e7a905be1dc288d1db6e4269ed54c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "676cd6b940e819a6630f52e0ff8cac950c1e83b3d0144b7a2788dcdf52606c61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8304e127ffb40e40f1539794c057d724e53423d9189cdebd40af69c08662b533"
    sha256 cellar: :any_skip_relocation, ventura:        "6d1b08daaea50cc62db432fd20bcd42e760a0354f1fdec2ac3e78111e6871c17"
    sha256 cellar: :any_skip_relocation, monterey:       "f63e8977525e84aa74d475aafa50564e3d04d5235cd7b849ad1ef12aac1273fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "85a176c40e2eb87be8c4a8ee9ea2e42221c9ade3683820c8809c6ded70529954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b702bfd2b885b1b3173b5734befe9686eecbacc4ce0c178b97b48cbcbe897613"
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