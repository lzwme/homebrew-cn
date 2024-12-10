class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https:kubehound.io"
  url "https:github.comDataDogKubeHoundarchiverefstagsv1.6.2.tar.gz"
  sha256 "c7ee1b88dd6103f892876b5d19faeb2a099c1856ca3105e7536cdfbd0f0500de"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1d44cea2199bf6af2fdeb2c583ffd8d34b41e5760155810582f871610bda0e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783f6de6f634031ebd1517e2ac82bd0ea4524ab86c78abdb66c5aa909065ba85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ee61d8c04bea42f1ed748cda411b47805a258954bc2bb0eb348682c45ff6cd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff3ef59374a4de379a10e2f50f58895bfb2371bbe26604c350a59742726042de"
    sha256 cellar: :any_skip_relocation, ventura:       "cb06c8f53ac0d17d70e4614b868a0bd9b7369342617d44af32e430a4c2aba311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb3d0852067153524451c28ba34c0de4a454c8b4c75ce01e657bf80631068a5d"
  end

  depends_on "go" => [:build, :test]

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X github.comDataDogKubeHoundpkgconfig.BuildVersion=v#{version}
      -X github.comDataDogKubeHoundpkgconfig.BuildBranch=main
      -X github.comDataDogKubeHoundpkgconfig.BuildOs=#{goos}
      -X github.comDataDogKubeHoundpkgconfig.BuildArch=#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdkubehound"

    generate_completions_from_executable(bin"kubehound", "completion")
  end

  test do
    assert_match "kubehound version: v#{version}", shell_output("#{bin}kubehound version")

    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"
    error_message = "error starting the kubehound stack: Cannot connect to the Docker daemon"
    assert_match error_message, shell_output("#{bin}kubehound backend up 2>&1", 1)
  end
end