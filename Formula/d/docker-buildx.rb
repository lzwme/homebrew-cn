class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildx.git",
      tag:      "v0.12.0",
      revision: "542e5d810e4a1a155684f5f3c5bd7e797632a12f"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "316f90184d51579d9e80a5a38a3d93c176c8d55375215c4831a7a99db978eaa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02f9a1eaf4bba5c814319d869c51e2f4a3735edb3efaaa6024c4a2f2d36d3447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef0e340df516654d0a875aa8fa4aa9ba3cf5ebbf4006f0160b3af28b4d859fc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd2a75dc3d9a83a5d7ff486aa70a62d45aae05ff4a9dc2f9ceffd341e931efa8"
    sha256 cellar: :any_skip_relocation, ventura:        "5f708a0a7942fe2d5f15df48d855e73d9a0728b327f347834c4ef82589fcda0d"
    sha256 cellar: :any_skip_relocation, monterey:       "ecb3b0461d12213562d307c81ee2aa9fef5eea0730fb3174e6b29b968bf9431d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17342b7168b50bc0076f81da96da8cc93204c3974f26716fa905e767505b6ed9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdockerbuildxversion.Version=v#{version}
      -X github.comdockerbuildxversion.Revision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdbuildx"

    doc.install Dir["docsreference*.md"]

    generate_completions_from_executable(bin"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~.dockercli-plugins
        ln -sfn #{opt_bin}docker-buildx ~.dockercli-pluginsdocker-buildx
    EOS
  end

  test do
    assert_match "github.comdockerbuildx v#{version}", shell_output("#{bin}docker-buildx version")
    output = shell_output(bin"docker-buildx build . 2>&1", 1)
    assert_match((denied while trying to|Cannot) connect to the Docker daemon, output)
  end
end