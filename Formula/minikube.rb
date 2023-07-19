class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.31.0",
      revision: "47aea544e09f11f475f33e8d126f9eb15e34a4c0"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "204e31bda848102e2c5e99d6fe2da18265ff427f9ae3dde6e05dc42b6c66f716"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ae3580eb31949a544a454742accb6213fcc1cc40931c2825a45c83567a0f9cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d27ad0246f6fb55d8b00235e6fd34f713922effcdab86c562974c818bb296d25"
    sha256 cellar: :any_skip_relocation, ventura:        "a8b421e8c2ddd692fccad23833b82262b718605abecb304dadeca1669bf0dfe5"
    sha256 cellar: :any_skip_relocation, monterey:       "616bb7bdf8a8dc21e7c898fd0df75452f58df6ed2e3c3670ac4d4625ece102a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "144690a34eb8f177e848ea3a7b262b5337871c7ad07d679f8ac519ae991aa8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b57f6d0953c1f5da73bfacb92e0b0567b15a0fac3c58767984c8c29619b7be98"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    generate_completions_from_executable(bin/"minikube", "completion")
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end