class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https:docs.docker.combuildxworking-with-buildx"
  url "https:github.comdockerbuildxarchiverefstagsv0.14.1.tar.gz"
  sha256 "01e39cc6d674e20547a62f52d80bc3cbd6c1cff6764d7869e182bdcdd49ac297"
  license "Apache-2.0"
  head "https:github.comdockerbuildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4ec1722327f89a6f5fb9c6368cea37a60fd74b2550cc3163cbb82b145b367a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b435dee23c066e91e29fa33d27cd58f66d9c1a9964ba1d874a70ecfb3ab55065"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b3cd64055fa598a50818c55d510baa07891bd738afeba76e4b544db78954012"
    sha256 cellar: :any_skip_relocation, sonoma:         "519b2542b1d570714dacb1593bbc2d2fb208cac8c7667a3c06b8acb488d324c4"
    sha256 cellar: :any_skip_relocation, ventura:        "7a83c2cfbd50d912515d0214ac6c1f691ac5edead74c6a1075de87d18385ef27"
    sha256 cellar: :any_skip_relocation, monterey:       "0d9836b876af76cb39e2c87507e3fe1af4a026ed34ee2bb54dbb8549cf2540c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcfd03aac887e1da3248f57b755b4a34d5f94106275ad8ed87c502f140450824"
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