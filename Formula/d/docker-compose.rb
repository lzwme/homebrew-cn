class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.24.6.tar.gz"
  sha256 "14fffeba19b82c8e5a9cdf6d873522a11ee4e25bbb86bbdf468795274429db70"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf35ffa392f7bbe219d008a4c9510ec91293ca7de8c2b26fd5260dce520d65ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5a2eb89f50bc84398f054fb225fb9048771e584a7e26ff317076b57ae91a967"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8dee066b2f67b9ff90965194b25292cbc4a2d0e974ca50163656c5f48de51e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0644e7166e749f0641e989824c9bf5b4e1aeea9c48a289f7044584c9a9ac292"
    sha256 cellar: :any_skip_relocation, ventura:        "02c26ac9823e1b76a6b2a181f81f15f6b0b4b1a6ab3125a8b0df679aa9afd68c"
    sha256 cellar: :any_skip_relocation, monterey:       "ac0d186595c966c7a453f327188286935bff4d5dd06ed3379ac18a06ef4bf68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "144ed6f813d8caf11f9a24407dfd91fe415a85c0d0cdaa8e8ba1db6854a34a52"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdockercomposev2internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmd"
  end

  def caveats
    <<~EOS
      Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~.dockercli-plugins
        ln -sfn #{opt_bin}docker-compose ~.dockercli-pluginsdocker-compose
    EOS
  end

  test do
    output = shell_output(bin"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end