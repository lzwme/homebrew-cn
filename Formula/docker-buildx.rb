class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.10.3",
      revision: "79e156beb11f697f06ac67fa1fb958e4762c0fab"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1302bdcc3c6c20839027e67225f6f07ab946f58c7ce3b1a1acc68e98748ee503"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2147fd2955087ec73e743d67650fb96b4eda0b9263c548a420aeefdf5f68a001"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa2d08bafc9634eecf5efd969182cf0a27034e89f507418e042b6b3feb83b5b3"
    sha256 cellar: :any_skip_relocation, ventura:        "14b4f80a33b85ce25bbc61ef82bc2d3d99c23908562faa36b2d2211e7fd44975"
    sha256 cellar: :any_skip_relocation, monterey:       "712e6c7d009cdd4f07a7fc4becfc05765e09670da72f6d34739877df44e53ecb"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d6abc0c53e2342f028ac345ce0ae802ec48fe3b5742ef1f5233e77f7d60a6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "127f18347d3cc355a3910b56ae51342b7a1de96b6a1ea61a19bf6f7150307281"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/buildx"

    doc.install Dir["docs/reference/*.md"]

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-buildx ~/.docker/cli-plugins/docker-buildx
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end