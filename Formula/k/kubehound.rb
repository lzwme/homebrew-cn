class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https:kubehound.io"
  url "https:github.comDataDogKubeHoundarchiverefstagsv1.5.0.tar.gz"
  sha256 "74e794bc885999d6cae0ddc5e0e961029b33f53aab6050abbb6048a13d1289bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "198816f094b843cec5577ea41774ee34025739bef3553629ff603d95286b3741"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "289d7a2381b1f7328b38fdaf57d8ca0c75ce6ff2a532b668b2ea19be4b355704"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1116aa2b3199799d4134f696ef06fd3ee933bd8a68aa1f2b3a16f968278cc008"
    sha256 cellar: :any_skip_relocation, sonoma:         "77381e9ba28bb16f220f00c569084513beebf40b7d31482acc1151cf811c6b22"
    sha256 cellar: :any_skip_relocation, ventura:        "c3aa0eb7624f4b3cfe52527610bef57ac15c65a91e77649d6196686f539fe18a"
    sha256 cellar: :any_skip_relocation, monterey:       "e6e6e8d931cc2f11e0c5211792245c528437fb7d659a9e751dcd5bbe62a7d5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b02bf36003df008306ee8f2a7b40f9cf780ccd87c58774534a6ba409c545d470"
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