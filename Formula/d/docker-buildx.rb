class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.21.2.tar.gz"
  sha256 "fbb27467c5f532a2919706c4c76912f10aa19b04c5a87420a8fea6be3a870f18"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cdefbda86226e28c5209545107b3a40fcb2b0b98dc3212ccb0fab5673ee05d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cdefbda86226e28c5209545107b3a40fcb2b0b98dc3212ccb0fab5673ee05d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cdefbda86226e28c5209545107b3a40fcb2b0b98dc3212ccb0fab5673ee05d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "065f73908481275cab64faaff6bea333568bb2555a395cdc71ab04ee69862214"
    sha256 cellar: :any_skip_relocation, ventura:       "065f73908481275cab64faaff6bea333568bb2555a395cdc71ab04ee69862214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c5ad0be7910e59bfb2aa35c04f21f886c333952f3638b5f14a8bb18c75b5552"
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