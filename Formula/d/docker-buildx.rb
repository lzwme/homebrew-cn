class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://ghfast.top/https://github.com/docker/buildx/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "b2d9ae781b2f693fe145969e3ebfb02f88aa365d0e0f4bb2578759e634b5b98b"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e209a626912112b05a4a207473f4879734ffa72bd7d36c86aa9deaeed2e6040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e209a626912112b05a4a207473f4879734ffa72bd7d36c86aa9deaeed2e6040"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e209a626912112b05a4a207473f4879734ffa72bd7d36c86aa9deaeed2e6040"
    sha256 cellar: :any_skip_relocation, sonoma:        "0016345b980dd86418dc8264df5e0ec1f75abd8479fc4cf3574588aaffd5d4bf"
    sha256 cellar: :any_skip_relocation, ventura:       "0016345b980dd86418dc8264df5e0ec1f75abd8479fc4cf3574588aaffd5d4bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aebb48ba78042b02623115e958ccde68a2aeeb27fded33865ee79237a6761fb0"
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
    output = shell_output("#{bin}/docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end