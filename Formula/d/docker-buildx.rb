class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.16.0.tar.gz"
  sha256 "6660afc93ed7b6f1046cf179b780d8c0d9ee35fc3ac8ace78af49b7ea63969fc"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d7cc0fe3985fa0fe63f47bf2abeaf8ee58938d46235cc58c2d3dd0ac63e5a50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "190a006da3600b6b83da7d6b46ae572ec4f0080e112b10ace04e947763e41a00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70fd38c596e13e613dfd4edc4805a334a74b4621f43da00546c7cd0cdf062f9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb3d17f7ce7676fb90afcd17d51617af106557ed1cfdc572cde77c68bb1b24e7"
    sha256 cellar: :any_skip_relocation, ventura:        "f91f44ab095938acdcf468bce06582ce6ae8eca9ebae3e4d4c60735b38a0dc37"
    sha256 cellar: :any_skip_relocation, monterey:       "54e8560bbdb5b2966896d4992d695fc77648d858c373c06a0e567321080847b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e57291870f6346d3efebbb2458e6b82f091f3590d419ce0568abf861405001"
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