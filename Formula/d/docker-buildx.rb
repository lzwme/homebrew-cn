class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.19.2.tar.gz"
  sha256 "f45cb0d465ef0bdcac5136764db33626280fb8720dbae5f9565102e1af58f3c4"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b545e612ae9ef19fa99f4f8bba94fe37dd83a3ea856ea79e308d19b905c0905"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b545e612ae9ef19fa99f4f8bba94fe37dd83a3ea856ea79e308d19b905c0905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b545e612ae9ef19fa99f4f8bba94fe37dd83a3ea856ea79e308d19b905c0905"
    sha256 cellar: :any_skip_relocation, sonoma:        "79969dd93057dd25917a1b1e391319864cf5bcd7f76e09a872c1e615afedf66c"
    sha256 cellar: :any_skip_relocation, ventura:       "79969dd93057dd25917a1b1e391319864cf5bcd7f76e09a872c1e615afedf66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd02583aa271135ddd314f92238595744d5cd8dcad6c8ea6b2c3eee86adfe3a6"
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