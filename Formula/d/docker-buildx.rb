class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://ghfast.top/https://github.com/docker/buildx/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "0f03a53c483f45bf8dc045a77516c3e40bce2fb94609c53aa7a6efa4cca664c7"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bacf605307163a5d2e3c5947904ed0728bd5f3e246409ac30058ae204445256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bacf605307163a5d2e3c5947904ed0728bd5f3e246409ac30058ae204445256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bacf605307163a5d2e3c5947904ed0728bd5f3e246409ac30058ae204445256"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a9fd35c24baca97bac53819ed60be589dfed32056773dfc43c6135976e3d56d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "956ddc21e049f1350de1411b52b92b15affd4a1e2127aac95c9f9627941e511b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771aa6beb855b53eac3151481fefecca223a992bd5139627974eeb42df47dfb2"
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