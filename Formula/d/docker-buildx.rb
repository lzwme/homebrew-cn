class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.19.3.tar.gz"
  sha256 "981a17d5763d9583c6c73ac194d4978de6fb632e3818fa6d983aefbc0c02f844"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35d5b5977910f33b2ed7c749477cd8de134ac8243511e9db5624c36d2c506aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35d5b5977910f33b2ed7c749477cd8de134ac8243511e9db5624c36d2c506aef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35d5b5977910f33b2ed7c749477cd8de134ac8243511e9db5624c36d2c506aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "12bd58848d0273bd11abf961ec90d304ed5d24fa86e14b26193d5a11eb8cc66d"
    sha256 cellar: :any_skip_relocation, ventura:       "12bd58848d0273bd11abf961ec90d304ed5d24fa86e14b26193d5a11eb8cc66d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c8f5fc7439173b85a7cdc6273648166647ddac2b21d6a1d9f0ef1f7c929051c"
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