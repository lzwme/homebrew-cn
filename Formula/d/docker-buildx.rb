class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://ghfast.top/https://github.com/docker/buildx/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "c3e7c577dc4b3e0656d69e2cb3651a9bb49776732cb55583652465d25a9675f4"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54a1d771eea1d7c9663cc2608abe4a1c461aba6401ed9ac6108e7d26f9bcb9b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54a1d771eea1d7c9663cc2608abe4a1c461aba6401ed9ac6108e7d26f9bcb9b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54a1d771eea1d7c9663cc2608abe4a1c461aba6401ed9ac6108e7d26f9bcb9b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6126a888d54b378d38f5f336416aaf15dfdd0f5e3beba826d09d5a3e2775062c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "674efe4da87d4f49ab7b483326b3da72ed4da3d70f3349d54617e59f96cef0a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3f0224f272424742854c6bc7d4228df132f80fc48ffd2dda01a1ac07acacf5"
  end

  depends_on "go" => :build

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