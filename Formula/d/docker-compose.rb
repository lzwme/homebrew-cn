class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghproxy.com/https://github.com/docker/compose/archive/refs/tags/v2.23.1.tar.gz"
  sha256 "9b4fba785b09d6745c35fff440cf5e2ce80bf7216dcb048535a7761dec492d11"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a991c58cac20c46f79584f6dcd2bf46a9f536b23fd6f8d054a06acb5bbe26bb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d0b35ad3857c7e43d850760306cfc4c026b4f2dd146379342eda2fe6e72b5c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2bdeba3213ba90a578064738faedb0cfbac43e8456f6dd84ac3583fc0e0c678"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dd71879211ece3e124817f457190ebc77c9f4f3e7c2a201e52099b5d6a0658e"
    sha256 cellar: :any_skip_relocation, ventura:        "8d55013eff30536165d9561385024f6108c5bfc138605401ff84aebe969e7135"
    sha256 cellar: :any_skip_relocation, monterey:       "3ffdf8c336b6305c2eaa64ef0d08738ee94da71c58185deef675e506b788884a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64de4d4bd9c9415829d57c74b2501efc35ca3d97f0724fa4758f86cbb67dd9a5"
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