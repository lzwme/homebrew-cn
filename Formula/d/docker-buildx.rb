class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.20.0.tar.gz"
  sha256 "ddf784d450c1a225b3308a4cc71e18e72beab7d99a73ede5818c7ae9c9431041"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7e640ac8a78de5a31d78b851078f9e0e9ac802976633b28dfc50a9d101cfa1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7e640ac8a78de5a31d78b851078f9e0e9ac802976633b28dfc50a9d101cfa1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7e640ac8a78de5a31d78b851078f9e0e9ac802976633b28dfc50a9d101cfa1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c1b280127a1cb4b1db0fdbc9cb03ce634fd3a53396af482ba6dea80fd79d753"
    sha256 cellar: :any_skip_relocation, ventura:       "2c1b280127a1cb4b1db0fdbc9cb03ce634fd3a53396af482ba6dea80fd79d753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a760599b84427b3c326bcfe27ff96916b51730e6592379b43cf5580d7191e02"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdockerbuildxversion.Version=v#{version}
      -X github.comdockerbuildxversion.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdbuildx"

    (lib"dockercli-plugins").install_symlink bin"docker-buildx"

    doc.install Dir["docsreference*.md"]

    generate_completions_from_executable(bin"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~.dockerconfig.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}libdockercli-plugins"
        ]
    EOS
  end

  test do
    assert_match "github.comdockerbuildx v#{version}", shell_output("#{bin}docker-buildx version")
    output = shell_output(bin"docker-buildx build . 2>&1", 1)
    assert_match((denied while trying to|Cannot) connect to the Docker daemon, output)
  end
end