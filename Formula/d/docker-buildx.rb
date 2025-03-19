class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.22.0.tar.gz"
  sha256 "afcfea302f639f86299d41657f2ea6ca8df0d8cc3e243c299c8ada0ecfbb1fc4"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e64691f2667727dfe192ef41b21839d360f6d7e35198fa2377adde6a7c9e4535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e64691f2667727dfe192ef41b21839d360f6d7e35198fa2377adde6a7c9e4535"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e64691f2667727dfe192ef41b21839d360f6d7e35198fa2377adde6a7c9e4535"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1954553b96b17896879d4f9c6134e37f5d2ed3ac8cccb0104706174e7fe0763"
    sha256 cellar: :any_skip_relocation, ventura:       "f1954553b96b17896879d4f9c6134e37f5d2ed3ac8cccb0104706174e7fe0763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00ed3e5d63c8efcbe6f7f038ed02b378d47f93b6be449f22a2caa497f5fc867e"
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