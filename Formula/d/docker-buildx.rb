class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://ghfast.top/https://github.com/docker/buildx/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "f4705415fe4e011f19c6fe0fa324fef81236791815c51bb6210b3bbbca5b1319"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4accfcfd6ebc0f7ef47db24b93447bd5e1751cc74b2e1874e8f2e11b0e02d806"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4accfcfd6ebc0f7ef47db24b93447bd5e1751cc74b2e1874e8f2e11b0e02d806"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4accfcfd6ebc0f7ef47db24b93447bd5e1751cc74b2e1874e8f2e11b0e02d806"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb60f44e7da23fdf599d2309bd7d05848cd1d108c74accd60aba39b92136c547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cafde002ec747e49fc8b52e4eb0bf1b92bd1188e987162ec46cac951fa24c9ee"
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