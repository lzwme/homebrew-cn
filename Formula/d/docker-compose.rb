class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghfast.top/https://github.com/docker/compose/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "35287aff54d826241fb727b3024b1cb46849770ac8dd166f0702f8aa2b5f7e30"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39dc86959a146bb8d49fbc858730cb20340ca7a632fc6f1a4d69c83d46920aed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d9178399bf612a2bf11c2d57f52b6db1ae34e2d0523e6fa06e7d72296990af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8bd76636354adda8e18f3a165b0f794b9faafc3829afcf8f44cf978ddcfa9bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f6e2c57959415eea3e7be5674519c4673d50ee8dc5901a7f44bc44ac32fa6da"
    sha256 cellar: :any_skip_relocation, ventura:       "252cf4be6fcbada38fa661ad4a1e25b5f3609abe07f018346232afedb90d5bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d1db740ea42b50f746456cfcc51778a7f3c35a7f488f55ea48736302a19f341"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-compose"
  end

  def caveats
    <<~EOS
      Compose is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    output = shell_output(bin/"docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end