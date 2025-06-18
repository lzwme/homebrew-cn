class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.25.0.tar.gz"
  sha256 "e5a7573a5995c0f12c86d35a8148b2a10a6f1b11d1cf8c6977bf03ac281e6959"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56f5de9cf36c8afd803e6e69a6d6bb6d9d2f249d880d5c2f812206df15c4ea15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56f5de9cf36c8afd803e6e69a6d6bb6d9d2f249d880d5c2f812206df15c4ea15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56f5de9cf36c8afd803e6e69a6d6bb6d9d2f249d880d5c2f812206df15c4ea15"
    sha256 cellar: :any_skip_relocation, sonoma:        "b09ed1d3751f138a0df220bc5126409779e3a092f1b6b04ff7cc8ad74b74f910"
    sha256 cellar: :any_skip_relocation, ventura:       "b09ed1d3751f138a0df220bc5126409779e3a092f1b6b04ff7cc8ad74b74f910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15525a520232b7575097a146a1430a2afa95ca03bc1fdf5187a01bffe6431708"
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