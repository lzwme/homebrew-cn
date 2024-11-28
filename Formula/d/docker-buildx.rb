class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.19.1.tar.gz"
  sha256 "7a14199d052d4933bb5379207f13d4b6562ab10f3fb9f5217790b482bd2b25f4"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fdd5a38e02f29e6f899e8e492e5e21679df20ca82336411b56896f89ca30b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fdd5a38e02f29e6f899e8e492e5e21679df20ca82336411b56896f89ca30b2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fdd5a38e02f29e6f899e8e492e5e21679df20ca82336411b56896f89ca30b2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "532b925a6c16d98a9477dd23ccd0e3d1aa8a9d7ff45c4b46f24f546f8d8958de"
    sha256 cellar: :any_skip_relocation, ventura:       "532b925a6c16d98a9477dd23ccd0e3d1aa8a9d7ff45c4b46f24f546f8d8958de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e62a0c061389ec4511f71cd61dfd852a96db45f4f9f1b65e4c708695bc144b"
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