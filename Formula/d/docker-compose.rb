class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://ghfast.top/https://github.com/docker/compose/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "496ee43bc6ecee6fbac28e93f6e784a7b0207baec7ae2b0ffb57cfd83bc92874"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14e4c83d2f2c824af7046ca1ce532b9ff823464c1caea94d3968f3be226d8316"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d316fa23346d9f844562ae62a63fa13d421b2037129953ca6525c2f649d56240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91d7781904a4228534a3eda0013a0bfa881f021e0c389ad9a7f5db6b22ee522"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bd03d5298514055a21d30a46811f1c0fface305fd2b1fdaca7c540c0715cf16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7f2705e4e498bb3f952a06d12992638c9301281435e7c087642b83f4ccfa42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21210f9a352d063152eab0a3b754b212e4ac2e1147f3fd413711fcb53f8c764b"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v#{version.major}/internal.Version=#{version}
    ]
    tags = %w[fsnotify] if OS.mac?
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd"

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
    assert_match version.to_s, shell_output("#{bin}/docker-compose version")
  end
end