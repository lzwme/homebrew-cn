class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghproxy.com/https://github.com/docker/compose/archive/refs/tags/v2.23.2.tar.gz"
  sha256 "aa50bdca0b7921002cc3556eb42343d2922459ce4ac43bb4bec46e6be2fda07a"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "747453d872834b157d951d25653f9c71885106f977402561e1ab54b155adc523"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acbb14c6689786c91927e5bf3b8f2f5a6825b76059c7dd0914eff6d402b1cfe0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba82e9dafbd063944a24c59f96005f3951a0c9386fedf62334d6d4e5eaeb34c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dab93831a00bb35da021bb1552ce5534adb4b6b66c8dfaabb967dd5a2e2e3d4d"
    sha256 cellar: :any_skip_relocation, ventura:        "342cf80ce0392ec9aa8cf7ec6a6bb9e0e69778de269de0991bfcf82a6b69ed44"
    sha256 cellar: :any_skip_relocation, monterey:       "dd587b1c3d32140b20413324fdca00b1a5d7bda83321bef3f3600877926f2ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87044ffef65345658581da6582b792dce6741c673d68e5e95f9784c286c65e6c"
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