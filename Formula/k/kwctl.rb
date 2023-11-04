class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://ghproxy.com/https://github.com/kubewarden/kwctl/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "9f770025338b7b5a5097dfe9fd128c39eededf0237ee9dada06376d846a674ea"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ae953ad3c30995e0f9cfaef70854e51da392ea47e160add7f28dcea1f8cf94e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8671cca3c4572bb69e841721f9243b9b2ce0b6cb39b60d3ae5d6efd825424cd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1adf6aa92b5863ce9674cea60b04fe36c5aa3c4ea03fefc97e89a23a7f244d2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "96198fa8f45b5ef8672aea55661dae920992b15fe91eec55fc6f9a01a74c888e"
    sha256 cellar: :any_skip_relocation, ventura:        "ec098ed76fb15a8c3ba8d83c6e7e45691bd0aeb73bade7d816dc0f2771bdbcdc"
    sha256 cellar: :any_skip_relocation, monterey:       "b06edd43227eef98271e27d6b4692e98caa7207cdd3a2b6e29979764469055dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cadc9a52e305f2d9aa39d40e11d4803b0edacf04e9664b97af3213ff3db721e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system "#{bin}/kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~EOS
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
    EOS
    (testpath/"policy-settings.json").write <<~EOS
      {
        "denied_labels": [
          "owner"
        ]
      }
    EOS

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end