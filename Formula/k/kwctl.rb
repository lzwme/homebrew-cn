class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://ghfast.top/https://github.com/kubewarden/adm-controller/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "8b9b309158322265d30e6b83fc3ccfd427b525ea6660eb404ed89dcfae1a38ae"
  license "Apache-2.0"
  head "https://github.com/kubewarden/adm-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0f784dfd149b89c49ec7918363c51e00874a4a956f752ca4c70f471f2b29051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b16f2894362ac0a3dd803724ca2f2792461409658494156cdd427ad87c8983de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35449ea34c3fd00a2ed7c0010b59cdf76a70a12bdcae709e9e7d6b03e779b14a"
    sha256 cellar: :any_skip_relocation, sonoma:        "13f3e8bf0fbc286a059f4a8ad94968affdce5890583cf103f27c266c323d0ad1"
    sha256 cellar: :any,                 arm64_linux:   "890d9b81cc3965b5e5fa50fe7951ba889f2949c7911915005e8f38fcc18c3d0d"
    sha256 cellar: :any,                 x86_64_linux:  "1064b00e86ae30b28d7674dd970011eed8a8fd12b38bcf787ecbf608a5211eb8"
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