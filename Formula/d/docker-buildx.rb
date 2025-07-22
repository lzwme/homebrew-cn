class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://ghfast.top/https://github.com/docker/buildx/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "de6930b6e85df69e1e42ae9b21161e97f3f4f635647bc050ba84f6d51b16fac6"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406200d10836ef4019dd3c1dccfbf56bbc6452bfd473bf6ae3200f6ca44540d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406200d10836ef4019dd3c1dccfbf56bbc6452bfd473bf6ae3200f6ca44540d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "406200d10836ef4019dd3c1dccfbf56bbc6452bfd473bf6ae3200f6ca44540d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c935c3a3f9f30d61854b007f93217a8a0e17019871e96e9741114ea2de56f8a2"
    sha256 cellar: :any_skip_relocation, ventura:       "c935c3a3f9f30d61854b007f93217a8a0e17019871e96e9741114ea2de56f8a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d3369950d119c1ad4ab336193bba971e60d5d783ab0d3fa1856b8dbb3ccf15f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"

    doc.install Dir["docs/reference/*.md"]

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end