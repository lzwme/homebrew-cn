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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5bbbe5135135e90947df4aa03a8fd3263759dd15034b28aa839216362cc0964"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c331ecebdd92fb2e0c451c2ec70867e8639dad5b3c116669869f57e60db4f3dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de5099022f3bb38429a4de60573a405111273d65e0265c5f10c86e6f3dbae099"
    sha256 cellar: :any_skip_relocation, sonoma:        "567bc3440e0d34ad24ef0a639c57c03e657c31c61d2d2c18799b9a80a18f6d6d"
    sha256 cellar: :any_skip_relocation, ventura:       "533f96f0951321a2cff3cab88f0599022ce50feca9fd03c88e4ba847660c54e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c2aeff4fc25c2e704ce5088f401bc726956a85d11ff79a033f53ca2543c55fd"
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