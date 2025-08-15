class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://ghfast.top/https://github.com/kubewarden/kwctl/archive/refs/tags/v1.27.3.tar.gz"
  sha256 "3ad10d4a77e9652eea97d80a8c12069cc7b5ca0024dc905522710c3d05703cf7"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c42ace3afabfc1fcc5a2dfaae01ba8867c50f2b5bc9fd997785ee0b162afa7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3c756cb470684b2b5755d20aaa29c378919d3e65b694cd5455d05d06f0c37f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daf7724ada51f36ce528f0de9e4d8a829601299fc22052b7fbd50a6c9810f7f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "452a8d1cbf6eca9dbec0247b0f197d6bd70e0f53752de50b45563792ca13154e"
    sha256 cellar: :any_skip_relocation, ventura:       "5d5b383597025c1cd2d4ad444329abd22d83f9fdd7fe78d279688d3d2899a0d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3d0047bb20a19365f963403db056596e12ccc917e17902732a3bdb7e25b0854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b858c2a923323161d8c6583af94317ace281542f3036e741915031fd451a0b23"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system bin/"kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~JSON
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
        },
        "resource": {
          "group": "networking.k8s.io",
          "version": "v1",
          "resource": "ingresses"
        },
        "name": "foobar",
        "operation": "CREATE",
        "userInfo": {
          "username": "kubernetes-admin",
          "groups": [
            "system:masters",
            "system:authenticated"
          ]
        },
        "object": {
          "apiVersion": "networking.k8s.io/v1",
          "kind": "Ingress",
          "metadata": {
            "name": "tls-example-ingress",
            "labels": {
              "owner": "team"
            }
          },
          "spec": {
          }
        }
      }
    JSON
    (testpath/"policy-settings.json").write <<~JSON
      {
        "denied_labels": [
          "owner"
        ]
      }
    JSON

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end