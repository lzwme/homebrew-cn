class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.15.1.tar.gz"
  sha256 "af8a6733b166c7b7676348e7553b1abaa9e62b416827f1be790a8fe7ec21c8a9"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aed82572698490e743af2afbaae43f0931bd0c1c55114ad98b264708892d0396"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a93a48637a7276e4aa877e5ba8dbe286814cd66e630d2cf67828834e4b53bef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b9731260f52081d70c33b39e9a512b685a24cbc536de6c82a13a9e2ca112457"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffb457bd9cda4e95e4fc1e07f27102e6e0fbd6a907e62a66304f8b5b40ef9291"
    sha256 cellar: :any_skip_relocation, ventura:        "3e63522559360cb377525a430d519868d56844db70fd1d02cc5a6871fa6b8978"
    sha256 cellar: :any_skip_relocation, monterey:       "941a0f4fbffc2b10f6d1a01afd358c0bd8eb5e79727fbc85f27daf0faa3592da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0d41829540d99b5cdf231b88942dd2dae1723b2c433948997edc461b2988987"
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