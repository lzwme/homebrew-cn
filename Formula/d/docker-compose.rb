class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghfast.top/https://github.com/docker/compose/archive/refs/tags/v2.39.2.tar.gz"
  sha256 "3d082806391381310ba509a106dafa01c435b86b15818de541afe9d6c68a1cee"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf11341fa3add77cfbe6b3f3878b8fd2f21d6c1bae17cf2253994df73121512e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a05ae2029b6951358d5b8ae237e0f976a0170498a42e7d96d78363589761a1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2d8a9934b6ca1768be00b1bd1ab5e8efc4eba24272cfa0be76b83a3d0f9c6d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5520bdaef7f5bc0a88686fa05e1d6e6e28ea6423a0f5a26108ca332d24464e7"
    sha256 cellar: :any_skip_relocation, ventura:       "5615869f1863996ea71d31d011b03e6f27671f8897b38a8e186b8681288ae784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a70170a9cd2a0731f956e882715e53c80cd613220dfaf2219b0d0cf881118e8"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

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
    output = shell_output("#{bin}/docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end