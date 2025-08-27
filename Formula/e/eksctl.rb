class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.213.0",
      revision: "fa44f64990b98544718865218d75ce58f6f7b208"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16877bc3f952cd4edfa61630f15aebd982901d68e3a118140e1e0c217808164f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c956c87ea7944ed14587b55c096e184bc0227bf3b434f83062ed43396c7dbabd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59b360284ddfcee19ebe5661d300f0966b27e0222a4125d1e21f04a3ebd6bed6"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e8dba832cc8e46129936f1907fbb83f9a1dc8518d6cd490f156dab18829696"
    sha256 cellar: :any_skip_relocation, ventura:       "1494d59e44b56088ec0a66296571af501ae8193c3b4d3842fc9f93aeda665fad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cee841c01d2a675ac0663e5341215f75cc11ed2d836de7077dd00c8a938dd659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8994bfc98e8a5cd480d7fe4227f475dee7c27c9f18f9cd30652f55c0d63e3d1c"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end