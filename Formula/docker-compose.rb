class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghproxy.com/https://github.com/docker/compose/archive/v2.20.1.tar.gz"
  sha256 "6fa6bddc91296f72be84841a54cb2c5920d87977e39f78689cf6b2458c8e5e13"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65f49d17f7f27485d7fc850233ec0f01278b26f9734b4e3665eba5e859b7336f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aad38a4b8b0c2135fad5254e8864f7134c43f5e4a94a57ec3164a012bc66366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea869b1de0e0827b7a693b424cee9ac51ac7f5e61a9de7c732fa405bbafc263d"
    sha256 cellar: :any_skip_relocation, ventura:        "dda1a440805e1da640e238ef81eb5f1206143af91def92483483a70351f127b7"
    sha256 cellar: :any_skip_relocation, monterey:       "4e60b28f406bf9cd685b0a043159b698c43b803a655885e75820fa9a8bdf6353"
    sha256 cellar: :any_skip_relocation, big_sur:        "f606d73683e055589481f71260c5d4f44675a78d78b0955666f3dc1804287bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aa294e52d2ec8d913a740de51cfe87e9252c409821e9a6bf376348de6c80e07"
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