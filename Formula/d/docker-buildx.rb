class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.21.1.tar.gz"
  sha256 "dd7c160d7b7bead1df3d65df3cd2a689570b615ccf60029e6f6f0b372264f64f"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b80763d4bcb599ad4f77eea43de2889d4edf8a8ca6ee5b6afa475e680b6fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b80763d4bcb599ad4f77eea43de2889d4edf8a8ca6ee5b6afa475e680b6fbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51b80763d4bcb599ad4f77eea43de2889d4edf8a8ca6ee5b6afa475e680b6fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "06c9c899d813778e5789de7557b8dfca9c6f6e36f2721e4ea14669bcd5f6744c"
    sha256 cellar: :any_skip_relocation, ventura:       "06c9c899d813778e5789de7557b8dfca9c6f6e36f2721e4ea14669bcd5f6744c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08272d3f34d7a1c70b40fb29e2772101c3ea1ab277f41f3f04e9bd6c15ee1c58"
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