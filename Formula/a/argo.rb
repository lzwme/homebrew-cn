class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https:argoproj.io"
  url "https:github.comargoprojargo-workflows.git",
      tag:      "v3.6.9",
      revision: "138b39281cb519358605a2adbe9f60f1300c667b"
  license "Apache-2.0"
  head "https:github.comargoprojargo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be6c8c7da0e06cc95196574bf287f4eb67419cfb1218672fc04bf0095d1d665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdfcdee846d60f051e71f1613180074deabb6fb80d5ba5652c2a204ffa9d65e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f11783c714617d2ffa8edd631815ff96b00a453c201c3c495e77381d1e5024f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a591f3304c07f0dc83b931222d8e91298554de6db25e5b0ae1cd94d24d8b620"
    sha256 cellar: :any_skip_relocation, ventura:       "6d207808ad742598dbf0e3dcdfd9f726f733d8047796bbdd0c4acc6c21e71856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daae51d345dbccad636fbfc9ca77f1be353edd07e2f2011bcf096dc1d6973d0c"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "distargo", "-j1"
    bin.install "distargo"

    generate_completions_from_executable(bin"argo", "completion")
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}argo lint --kubeconfig .kubeconfig .kubeconfig 2>&1", 1)
  end
end