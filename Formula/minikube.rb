class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.31.1",
      revision: "fd3f3801765d093a485d255043149f92ec0a695f"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5142cda302d12422eaa80aa03332ee08ddd43ff982a9f326de2c049fa3e2509"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da06520636fc8dc7f2c5a49bcbcf1ad48d84610151457730474bd20314e30339"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76944384bc97d168e27019e32d7893811179c151c469e31b312978439f0a75e5"
    sha256 cellar: :any_skip_relocation, ventura:        "fd51d7d460f13936c28ed4ea873fb048fbe407ffce55b56bc3f294f9520c8b77"
    sha256 cellar: :any_skip_relocation, monterey:       "0a1d9575babb19680192260951564ddafe54222ed7f9f9844d8078d0da8f6af4"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf1debd1bf215541dc2a6f16d2e1b69a8ff781cb518af3cf783b84265ca92937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53887f7b678d85fa88b4e8735738b3776a4db892553857255c94d53ed9900124"
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