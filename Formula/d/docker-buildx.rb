class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.18.0.tar.gz"
  sha256 "a935cb2715a5054d918d40ef07cdd4a6465b20a755d466248718ab59fd41c334"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad07f34068d46566f8a8b6e037e315f286d3e0264c5f0547808a9df3aa6de199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad07f34068d46566f8a8b6e037e315f286d3e0264c5f0547808a9df3aa6de199"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad07f34068d46566f8a8b6e037e315f286d3e0264c5f0547808a9df3aa6de199"
    sha256 cellar: :any_skip_relocation, sonoma:        "2414b0b80b0da1281c6be0900cc06dfd8b4f88df64ae7780680a17175b02fabd"
    sha256 cellar: :any_skip_relocation, ventura:       "2414b0b80b0da1281c6be0900cc06dfd8b4f88df64ae7780680a17175b02fabd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "402365f690880d8702b078c2a767d04f1846d65bee0cfafeea3cdbc83ef1d3e3"
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