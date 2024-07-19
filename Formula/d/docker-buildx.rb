class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.16.1.tar.gz"
  sha256 "8c9dd3fb18ccba399223ba0f623c9fe09fa38fb2a05283131be8e4e139b2d8fa"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "678d9f05e428267a803ed6fbf4ab04dd461b34433644a6a80c37186022c7f226"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dd351569fb0a00161deae5aefdda192a95fd81fab667611d934e3dc67ba2b0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "649028018eff82cb2dd5438b37362cf0a76ea9d30147f41d234ccf1108e9b041"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc478638f6b782943bd0a3bc71527961efe660020226b7e45e6895e2d8c7c996"
    sha256 cellar: :any_skip_relocation, ventura:        "a3b3c0de7ceb452f49817a153c478d3a4b6a4248b1b880df3f7b08e6308b191a"
    sha256 cellar: :any_skip_relocation, monterey:       "88c142f5c3a3dd835d8c3d158ba25c3e03f855f9431502a8c25df010c83ad8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89348a31b575330f50dc91ec1746602a75dc7003e15b1fdff60868a7672c80e8"
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