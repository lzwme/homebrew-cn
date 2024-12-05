class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https:kubehound.io"
  url "https:github.comDataDogKubeHoundarchiverefstagsv1.6.1.tar.gz"
  sha256 "bdeb1c24f1f71b881ad722923e618178add1840ee66d9ca11ec3b78deca77911"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aeff970c4cfb6f2fdc891a634a721c522589bea8733ac6e1bd76d6f030ccef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b450d16e07f8084dc119202a6d1287b79f5604a5afde3d7713ea2723f90077"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e30431bf9610fe502be6749548b385c86a49e0886e23b384cec8c7a0b873b75"
    sha256 cellar: :any_skip_relocation, sonoma:        "895a30fd5b7d028735c13f07fbff4d9a982291222b8fb713690804c089f52955"
    sha256 cellar: :any_skip_relocation, ventura:       "412506c37e3970202c4dbb5456fc90c04fa0ff17192f70e75a29d948829f00ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa79edcc9436c3ccd9760b82a83d374b8a02fafb0f458df05f7f60656aff8b7"
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