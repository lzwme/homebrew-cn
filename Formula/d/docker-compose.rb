class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https:docs.docker.comcompose"
  url "https:github.comdockercomposearchiverefstagsv2.24.1.tar.gz"
  sha256 "6bc723e36c1bd6c83f83fc1ee65097df29c6780f5e136e61e53ef96316be593f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84dae5dc28206381eb10483a2e9aa253bd23a9805e20ad116c241b50f6aa7993"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47b151144056e1ac2ccb1a15a28c04ecb3ea3fb27249dab10209320e24fb0c50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "162cd3d9e2c25ce4bff8abfe431f6d55af412d35d8b312e07623e03e82e4fd56"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfacd587529034630281a35ad1fcc353819ed83e6a3f4b2a99a2e8abb8cd543a"
    sha256 cellar: :any_skip_relocation, ventura:        "8f7f95e8374b7548655f81d8e5f10f138cfc25bc9bc4f34e7d41cfa6815502e9"
    sha256 cellar: :any_skip_relocation, monterey:       "b939571de975a1de7b480a856066607314e12d59c3dcab2df5be4b5c48758ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722a6d132ea9a091925e014cf6cbbc7abe81fef85adcc4bd4301115190841d96"
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