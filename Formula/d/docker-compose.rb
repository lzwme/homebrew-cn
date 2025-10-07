class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghfast.top/https://github.com/docker/compose/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "4b4a0989ac393f7c2bdacda565a167ee0c7347fb20d1e6110477ad4d18b28a02"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d47f7f24c72e4cfee475a74500a102e10fe92f000063e3cb17b1a5fcdd0d576"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5e911ead5d0f5293392149bd3aa4bcdc17d00c421b10c527da901deb1e63f73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8f06c35e27dbe1b4a3eb99186ecc899bd3fe284194aed6fc8d7e80b07a5c8e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9007ffe0b128a8ba4a00fe65562a53547a0a66a4ff0d0ddbfa8edbb46c344a82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c50701802a50fd048825ca5eada7cab07990b5e635f133a19546e717fc09c946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff58288afd95093afcbb79fbefcf111f06991f6699e6e73026db667cdbc05e08"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
    output = shell_output("#{bin}/docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end