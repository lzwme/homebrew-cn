class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.29.5.tar.gz"
  sha256 "95d2b807eddb5b4d76c42d52eda3a384e021696646d1344d5fa2a767b1921d68"
  license "Apache-2.0"
  head "https:github.comdockercompose.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4ba06353d9617c5c82270768dc1cd0c9d5ee30849c859857321198eda3db858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62c334fafb4e2c2611cac2ffc082d8c799d6d0189d5a8495a8c515f3696c95b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e25e8b9c66076adf5563904cba3ab9fdd0883067e2edaaf0e0182e008efb3d8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e15b4ddef9e9a3eb019d087dcb2a2b4be307753b4c1b5d1b0f1eae6630a5f5a8"
    sha256 cellar: :any_skip_relocation, ventura:       "b6af5c06a50bc8d18605cfa0fa4e49c58d7749bba1231e5a3ff27bff8a852831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b9b62be8053ed94e59cf2b05f972ecf3f95692739a6658e1da4e9656cade398"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdockercomposev2internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmd"

    (lib"dockercli-plugins").install_symlink bin"docker-compose"
  end

  def caveats
    <<~EOS
      Compose is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~.dockerconfig.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}libdockercli-plugins"
        ]
    EOS
  end

  test do
    output = shell_output(bin"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end