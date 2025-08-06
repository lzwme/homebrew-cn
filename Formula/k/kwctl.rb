class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://ghfast.top/https://github.com/kubewarden/kwctl/archive/refs/tags/v1.27.2.tar.gz"
  sha256 "4fadb20d48bd43d61a083133d3199eea737c86134255f22675e8014cc6e7ae03"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b52997b20767e5bcf2d5e6b5eacf55bc194c0257548b3544c030dea2c7b2c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f0208df715b7f22b246933974467eb15b859b39a749019412dcba8ce15e403"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82ecfc5f353924e0605544dfe4d5a367e3ffb045334b733a4c8511ffff8eb4ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "c494209390393469b1c42ba598e9e227b75d0ea69ff85f472c003328c61a1868"
    sha256 cellar: :any_skip_relocation, ventura:       "9d9b0aa3ff398e20c842657d809d882c6e61453a45ba9a931ffdde5b0e193788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70d97ece0a84761025ae87f08df553b2436f5c4e71757a3fb4a20ca9c4f7e5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37da1d278511718000cbe1d22aa855611c69d50b5093ce022aca9eec5a74feb2"
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