class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.21.3.tar.gz"
  sha256 "f41fa334b5db45e58c7a63b9f7e6d905eb592de20f98cc19e87b2b6591ec1006"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d978033654f41f3d236fd834d4b8158538dac7ea1db291ea80ee9d28fa66b19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d978033654f41f3d236fd834d4b8158538dac7ea1db291ea80ee9d28fa66b19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d978033654f41f3d236fd834d4b8158538dac7ea1db291ea80ee9d28fa66b19"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cd44152c5a0526a60faafe41926a8e8c3eb9c51cdbfb52bb9fe4eede624e16b"
    sha256 cellar: :any_skip_relocation, ventura:       "2cd44152c5a0526a60faafe41926a8e8c3eb9c51cdbfb52bb9fe4eede624e16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b3f642fc8eac030e8e23f7984b62198d666103267b0032d1b194dc3463d2660"
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