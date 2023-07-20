class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghproxy.com/https://github.com/docker/compose/archive/v2.20.2.tar.gz"
  sha256 "f7aa0fd19fe457cb0310e3049f57253bddbf896a366824c3cd084a754967fb59"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10ee8ae6630a6c7b37bde0cf7c17b77881c0714845d0945e3bf7ad70b2d434b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ef8d2760d57e576891d3ce6cae663ef5ddde67c1a6cc98c2c147dad1113df5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bb4a8d7d5fa5b5537d47720322b8e394e58bab9e00e7593108359d2e5c07f91"
    sha256 cellar: :any_skip_relocation, ventura:        "c2742a9d69728e3a704426bf02933cbeb481db0873c2e40249fcdcd9c3f85d1a"
    sha256 cellar: :any_skip_relocation, monterey:       "2444187dd124455041747047dc83811e81a8947f1c135935acdacd01d0ba218e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8804f4fc3b8cef8c479ba898f84422f328244dd47b8528124c33b4f053059df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b916b03aa22b67432c8f28debef04998d011016d14d1f27918035c5384e12f0"
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