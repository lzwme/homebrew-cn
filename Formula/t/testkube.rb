class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.116.tar.gz"
  sha256 "8fdfeba3074ba760b4062a8d6d74090595794836a7e0b168cd9d39a272351f06"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f10fc33af94bb4fb0fdaf38f01f7de32d982d452fdcc9f56d6df3e00beae68bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f10fc33af94bb4fb0fdaf38f01f7de32d982d452fdcc9f56d6df3e00beae68bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f10fc33af94bb4fb0fdaf38f01f7de32d982d452fdcc9f56d6df3e00beae68bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "792f58bda186eb1c4570542bed9dd3fd1cb89acad43251da2a9da7e5ffb51133"
    sha256 cellar: :any_skip_relocation, ventura:       "792f58bda186eb1c4570542bed9dd3fd1cb89acad43251da2a9da7e5ffb51133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c1de7d8992ae8994fa67c924e6dec274f5e641abe319d59305152eba82ace4"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end