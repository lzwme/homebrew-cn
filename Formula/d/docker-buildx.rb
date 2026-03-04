class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://ghfast.top/https://github.com/docker/buildx/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "37066119b8673590dda39a0fd578e1d886b447f4871fa948cb7009045d8eea4b"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f9d974e3bdea10c8a74980881832ba96f48d83bb985702457c4fafc504207af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fff26bd87c516aa44ff30d731ef6e08ef408c4a3c63c4beccfc760e79da442af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d9b2f796f4d2ed58365ed44f33f28009e0f481d28cfbd02bbb7d144289acfc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "040e8a26b67d678d2950662eb5462219a3e4d131d17499f248fe76d6a8c1cdc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b81d37318cb14fc8797a791d0a42575bba1130de6aed9dad35cbd62afa910cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1162de41d82dbb1b94511901d54581d7d3acb2dc5086a499b163b67ee445d76"
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