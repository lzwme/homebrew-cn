class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.11.1",
      revision: "b4df08551fb12eb2ed17d3d9c3977ca0a903415a"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e3e84111ec962c479df51ba83a22d16baf91e3bdfc51b062e3a9fb96815ec47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e3e84111ec962c479df51ba83a22d16baf91e3bdfc51b062e3a9fb96815ec47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e3e84111ec962c479df51ba83a22d16baf91e3bdfc51b062e3a9fb96815ec47"
    sha256 cellar: :any_skip_relocation, ventura:        "98682517cc5afa5f1844b49f33e1046251f11213c0a9980267f80e729e493706"
    sha256 cellar: :any_skip_relocation, monterey:       "98682517cc5afa5f1844b49f33e1046251f11213c0a9980267f80e729e493706"
    sha256 cellar: :any_skip_relocation, big_sur:        "98682517cc5afa5f1844b49f33e1046251f11213c0a9980267f80e729e493706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c18a68894f31da963172f41334a6b42d6c56ed9870694f2314015cc7aa68f5"
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