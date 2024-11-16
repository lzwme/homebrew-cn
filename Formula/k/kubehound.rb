class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https:kubehound.io"
  url "https:github.comDataDogKubeHoundarchiverefstagsv1.6.0.tar.gz"
  sha256 "d77cdd05de70f4efa32db16f824ffeb04e9ddd6cb9be62e8be95579af3528213"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5a7aec6b3ab8071c74eb27613cdb632f79d7c145b5865c1f4537e02e0c7f85a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "442ca990c675846f5f4da0309e2d3251317bd0bc4ea1bad80b93483b8a6e2638"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "598f863b2da3863aa2a88a300fb8bb72017aad2b32666490cda0c14d9d0eec92"
    sha256 cellar: :any_skip_relocation, sonoma:        "05497b4858b6fa67a13414997f47b239a9a500d7191f43c519ff4075b9dc68ea"
    sha256 cellar: :any_skip_relocation, ventura:       "47a7fbe378a0ea9744654d3981f3906e2d499d225b5c1f954b67012d96d2eb86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c065f5524e14fdee16fa32785619cdf9f6e9edb1d8e34775138d4ba55ab196"
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