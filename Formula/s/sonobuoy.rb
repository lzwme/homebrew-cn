class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://ghproxy.com/https://github.com/vmware-tanzu/sonobuoy/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "52bc0105de79a15d3891a5afaea2b145074b59c19ec1d5d608a39097ef4412cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d500c567835fd99f7003647f44840e8beeeedc6f6ae0cd56e902af8b1d4d80d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10ee47f320b1d3cf8f8664ef3852634a77dadf4686044f051c3d0b6a43387b43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71b6f831a1de02d9102234eb9ad63c1401921f65f6368113c4ea7ffe388087a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6dd2c2ba2b1b2ea40445645ba23d7f7adbcc3ed4bfcea18d33af612579253e02"
    sha256 cellar: :any_skip_relocation, ventura:        "b33141f06fe5f73874ce64c77652c6c5fceb48e196cbc85749978b46ffa06d7f"
    sha256 cellar: :any_skip_relocation, monterey:       "23654575e89499eefb6f37d6007878c78cf6e179c690e9765fccb727cfb6fc46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6b1256672dcc4a6084a3ed23290c9321ecedee26eaed80b0f84c004df4a437"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}")
  end

  test do
    assert_match "Sonobuoy is a Kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kubernetes-version=v1.21 2>&1")
  end
end