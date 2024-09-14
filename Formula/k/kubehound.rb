class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https:kubehound.io"
  url "https:github.comDataDogKubeHoundarchiverefstagsv1.5.1.tar.gz"
  sha256 "d5e934f9c468aa286aeacb007903125f0832b762972fbc8a2c151c69bd2cb529"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe96b25c5d1168eb0048305d23e2dfdfaa86f28a225dbaea49aa5abdeab1092e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6b6251addb416350ca3fe5aecc53d99a280a6ba8c66a7707c0c95fd5739fc40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bdc22f9d668891993bf725919b65b0f91e8c8519c782f9515830f845b9e05b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "23e689b0190f0760bd8cb3fe0aa97ed11ca122210f98711c2f1e2a957cf98886"
    sha256 cellar: :any_skip_relocation, ventura:       "dfa367402d90a8728ec4f77c83af7226415e8b4e21d542ff7c8a303f6894eeac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c168ab5e155b62354cb26bb63d904ef41f74898e1279b921b40bb957f4ff64c3"
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
  end

  test do
    assert_match "kubehound version: v#{version}", shell_output("#{bin}kubehound version")

    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"
    error_message = "error starting the kubehound stack: Cannot connect to the Docker daemon"
    assert_match error_message, shell_output("#{bin}kubehound backend up 2>&1", 1)
  end
end