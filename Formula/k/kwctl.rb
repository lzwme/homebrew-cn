class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://ghfast.top/https://github.com/kubewarden/kwctl/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "623f02b927696d0faf4f89fa7de2fd42f612984caced6fb9599ed5a5c2cfe7e0"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4562f9bc9a15f4fbb23852df2a7cef90e8fd64d0c25c84a65bf8c397cdde99c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c35cace53fcc5d519ef0cf7249352b13319ed27a0c9001abeb2cc17e101c65c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79f9232a669d7c50bfcc89b58e865cb4b829746e27ed49da715eb346120b31b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b79b12fc9c4d0f0f77242f3fac16d0ae9ddbced8cf13d8c7f88319bb00a3485b"
    sha256 cellar: :any_skip_relocation, ventura:       "e65831721250030bf964b75b1df5b9fd9acb74722ef1b98e40059adc2cdac6ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c91a27f197ef16b2b918499f72b0bd78250ce0a07a63b9671231e6719210aa2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a01fc58251a65e02d789a044f41d5069e9bf45e1eb6110952a21dfdd49038b14"
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