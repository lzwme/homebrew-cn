class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.24.4.tar.gz"
  sha256 "a276cce106f65c139cc20530f5d32b546d86cccebca9fe4880246a814caa8034"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3756dbac11bf9e848109ffb4ab0b5063425b6dbe915827316f8850d6ae38db88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93677686102a5420554e7d1d4f9a7f29d38a389ed822a0a5288303ab34923060"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa8b6c419469bb5b2a7e89dab598b558fcb60670284e4deeda24a2dc9e9f083c"
    sha256 cellar: :any_skip_relocation, sonoma:         "16870d4f849d8b9406e2c6877e58078ad532386da9bbe68239d392caf5aca91c"
    sha256 cellar: :any_skip_relocation, ventura:        "011ce8b2a671a9356ca6a44808edb1cc1aa1eaa12438650b0db3c39cb3c65548"
    sha256 cellar: :any_skip_relocation, monterey:       "b39a939ce884031a5c45b822fb7ecf9664f00215330a9b01ee3b7f846b511cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "085a739a12146fe962a267f4d3f4e831b1e60f21de304fd3edf2f43a620db67d"
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