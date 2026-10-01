class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://ghfast.top/https://github.com/docker/buildx/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "6b4cdf64fd6b919b65be75fdfcfb6a42c9738730ee18453e26641132ecc177b4"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f38ac10413ccc680326bd1f123ee9ea47ccf08ba76f16bdf5ebac6bafdbc61f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f38ac10413ccc680326bd1f123ee9ea47ccf08ba76f16bdf5ebac6bafdbc61f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f38ac10413ccc680326bd1f123ee9ea47ccf08ba76f16bdf5ebac6bafdbc61f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f17d0ec9720eb2bb931cc03604c05f5cf9f76a1e33bdbe91570bf545b83c6600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9f09ec9d631fe7bec32c862b7a28643594efa39e4d3ed00690c7d1bb4ef0f5fa"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"
    doc.install buildpath.glob("docs/reference/*.md")

    generate_completions_from_executable(bin/"docker-buildx", shell_parameter_format: :cobra)
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
    assert_match(/(denied while trying|failed) to connect to the docker API/, output)
  end
end