class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://ghfast.top/https://github.com/docker/buildx/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "9a29405e4a156a7b428a0b4cbe6ae4e7d4a0e933871e3c6dd6241fe9c4a1a5b9"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "214e0eae7219c6cf1b5063a6281771877c63d72044ad1e8e865ed702e3e5cbaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "214e0eae7219c6cf1b5063a6281771877c63d72044ad1e8e865ed702e3e5cbaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "214e0eae7219c6cf1b5063a6281771877c63d72044ad1e8e865ed702e3e5cbaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "04f6581309cada833e76bb88f0b0cabaf345d7690da7c78bbc42b2ac9776b9d3"
    sha256 cellar: :any_skip_relocation, ventura:       "04f6581309cada833e76bb88f0b0cabaf345d7690da7c78bbc42b2ac9776b9d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4619cc8f1c0ab14d002e093d3b329fecb5f80d18db20803af105a78efe23dcc"
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