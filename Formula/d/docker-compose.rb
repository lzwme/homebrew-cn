class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.23.3.tar.gz"
  sha256 "29ba96c8d398fbc6f7c791c65e70b97e7df116223f2996062441093258d914fe"
  license "Apache-2.0"
  head "https:github.comdockercompose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c18c382593eb2cd4281ea9d0c2efe4b4d6b6f489575c206cca9b8f1b89ba044"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea898680e221604aa0e169ddb6567f72d592ac7d704f268c70941c76f5318ac8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a895f075d0ad9f892ac36e061641e5914c66e9a4dfb30276d90262751ab010b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3812d4f1c2299ad117087753477570e15d15564fde9f4cd27d8da65364dcb130"
    sha256 cellar: :any_skip_relocation, ventura:        "36b706f6707d7797ab59bcb8400c53619007a3ade1647b5c26d34ce73e31be98"
    sha256 cellar: :any_skip_relocation, monterey:       "3caf833792b2b9422f061ac4bf877b4dc54aaeae65d66ab5a5c67b0dda08033e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "203bbef9024916912d55c9162ce2f11968c6c863bbed4141793a3b664abe85ef"
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