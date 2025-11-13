class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://ghfast.top/https://github.com/docker/buildx/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "8acfd78fc74ad79d674f6305c7eb62807f592946a76e9a0451f944f74fc75e33"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa4a848548903a1922bf29dfd23f4f5eed7878131f0303e5f6dff26cbc07c38b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4a848548903a1922bf29dfd23f4f5eed7878131f0303e5f6dff26cbc07c38b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa4a848548903a1922bf29dfd23f4f5eed7878131f0303e5f6dff26cbc07c38b"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f37ec1ea6441e3a5056b090e5b13826414e5a68ef32797aa62eb9407b183cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f263831ddd9440fbe34aff561ede7ab72ccae9d28ce805f9e576f925c55cf62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a232f2ed052afa17e494399064ee2f8324c28e71fb0bb6f26770d19743580a8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"
    doc.install buildpath.glob("docs/reference/*.md")

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