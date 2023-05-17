class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghproxy.com/https://github.com/docker/compose/archive/v2.18.0.tar.gz"
  sha256 "e0b35bbc8c8fcfaffdb91351c59c9692f473ee24445fb919159e1ab8b83d2be5"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e2c5342109534cce4644b24b675b65ad4fd8981664705f23e5fdf6267d957ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54c5a0460dceae928f784c11322b7afab155392edbc98adb23c91334c8d667d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ed2701ac8ee1d339d541adb3d0250a4aecae08779af0b5f6bf1c3410be466e2"
    sha256 cellar: :any_skip_relocation, ventura:        "ea1578045b9a4fe2b70ca450bde918a0e7cf9be596fc2955da3e9332e433433e"
    sha256 cellar: :any_skip_relocation, monterey:       "acc3cdd771c92c72844d3b349ffdab8494b299cb615915c322e35d8b21950fb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "20c62418994d7d9c5e01de4fa90d86ee5e63657c77cf2b927f8230c74e96e520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8598de1643af3b7e032ba2fd145e79931c444811418fedac04d5cf91edfdd8d9"
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