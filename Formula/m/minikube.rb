class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https:minikube.sigs.k8s.io"
  url "https:github.comkubernetesminikube.git",
      tag:      "v1.33.1",
      revision: "248d1ec5b3f9be5569977749a725f47b018078ff"
  license "Apache-2.0"
  head "https:github.comkubernetesminikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9456dc2a0838f67ce50b36aa3bc3853b5d862c0efdd7aca03e27ab8cc411ba52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78e6bf4fbd4784578dbb94e6fd3863e9df345b634d86251a1add13bf5e67e8e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3d8801596cf3f5e8fd3c54c4aa93db23aa70b5695cca075110c9a42559b6457"
    sha256 cellar: :any_skip_relocation, sonoma:         "63d8530be4e920b62e3c283ea4639bec173e4ae82ee0958e529e3af4d5fdf883"
    sha256 cellar: :any_skip_relocation, ventura:        "0190fc08d4373a3f6a76918e73fcba7bcd5c2e2827063f80110d6b699cc9dd83"
    sha256 cellar: :any_skip_relocation, monterey:       "77220facd3a68fef1c340e3861d450fc8af5d603e4858f14710cb583a2f61b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4316c2b225bd115635d2e75e9b062ed8240570ad6836bd5d668fadbbd8fe4e91"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "outminikube"

    generate_completions_from_executable(bin"minikube", "completion")
  end

  test do
    output = shell_output("#{bin}minikube version")
    assert_match "version: v#{version}", output

    (testpath".minikubeconfigconfig.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end