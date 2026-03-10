class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://ghfast.top/https://github.com/kubewarden/kubewarden-controller/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "26407d202984acffaac4704617d82755d289a01075f40ab6d98fff73a8f88547"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kubewarden-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fca7f7642ece2c160ceefc71bdce66afa5f91c9d5729a22bbcc8c333e8ce6e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fedd58812def280fbea19d7472bb8947fd114564b3baa74d31f1ebd63dbea8ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1086119d74b81daeefeb303a06b583fb716cf6898106c2eec3199ec6f8c67a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fcef36c08598de3a9280a5ad9301a58f81ac8cefb3117b1cc6cd2c1de6af8d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbe32f06878de140c7b135c5598c9122eb96f239b4be48d8432ee4bd414feecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e3000ac285dd0415c7a6f7e682d4e02ed86c4506881f90ef5b655f55e548ef"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/kwctl")

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kwctl --version")

    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
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