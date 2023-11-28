class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.5.2",
      revision: "5b6ad2be163ecd3f0251a931ab84dba3c6085ad2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7c369d1fcf63ba5ca170d8d168d8254a17fb16e551ef7a282c57a59ead5e831"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eb41cc4844d08e5abe8dac8e1df2f8721fa716b0092fa4a4aeb5a400c57da0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f98714f634978ca88e13b6b294cc6f6f480ea394783298305b51be3a9488a4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e039aeaf5b20c2d4f8a36f0a0c33afc64f62f2cb832254165ce48d162c6cef11"
    sha256 cellar: :any_skip_relocation, ventura:        "51e2cbbcb22378598f89152cd2ed25c7992c4333fc1afb80786fb3f074791f5e"
    sha256 cellar: :any_skip_relocation, monterey:       "8d828a8a1bd50c6e285535153fc0b3ca4f96a426870029d8fe214458d4ba267f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74542c0b08a9a4c5134709447ff0d4f44baa41e97cfdea2c51d949de37ed3123"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end