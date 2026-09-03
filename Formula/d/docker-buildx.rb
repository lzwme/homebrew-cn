class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://ghfast.top/https://github.com/docker/buildx/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "c6e3efdfb9778d9ef69e005ea43abc3041511f088760c927637e3cf6be7cb410"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2332be4cecb7fafdd24e914e3eba2f5175016acc355d3db6c45e963b2861131"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2332be4cecb7fafdd24e914e3eba2f5175016acc355d3db6c45e963b2861131"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2332be4cecb7fafdd24e914e3eba2f5175016acc355d3db6c45e963b2861131"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8f3f78369a237b44bb3752a282f7c06e0690abf0ef2736e5fb25291dc71d555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f091de8cf036f82d9235438be7c046bf67cdc7a70a81fd6ee3dd793a365ed284"
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