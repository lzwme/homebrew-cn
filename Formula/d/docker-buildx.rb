class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.21.0.tar.gz"
  sha256 "3dc17a4b1ebfe1c3789e2b35f9eb04af9d2c1387fab980c68e58cf90408914d4"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60e6340ef486e44623f1dcd72b6cc9cae7dbe931f7f2c25e8ef7123d2998be3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60e6340ef486e44623f1dcd72b6cc9cae7dbe931f7f2c25e8ef7123d2998be3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60e6340ef486e44623f1dcd72b6cc9cae7dbe931f7f2c25e8ef7123d2998be3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "383708f86915695a9a89bbaa890389ebc5cec9667d084d3d106eb1c91ec59bb8"
    sha256 cellar: :any_skip_relocation, ventura:       "383708f86915695a9a89bbaa890389ebc5cec9667d084d3d106eb1c91ec59bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e409483abcd43362c051970f05f80f30701496cc616ebaba3ef92cdb464e0ce5"
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