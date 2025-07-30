class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://ghfast.top/https://github.com/kubewarden/kwctl/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "786dbb38ab53dbc1711a055bd5aab213b4eecb614c8620d9f923597f01a02632"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20b009bb86b5a0b92b67232307590bf67cadc4513757777167e6d34125e7d76b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e672e76034a27226881a0e5dff9d359b385d9d57957980ab6b34e015f808cc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7e4a093b28d217fd3c47435ad43925b22f1850f87e1a289ad64a3c321842730"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9e8a456f606ff1f7479fadc45e313787b8868c87c4fab5b4976dc501d34b1e4"
    sha256 cellar: :any_skip_relocation, ventura:       "37e415a5b7291e8528021f4e785e9c6552430d07507c27d89ac173a108a0b817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9935450ab6ebdf0cd34fb4a215a6b37ae507a26781bc38b3ae7d9b85c157b88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982989194138d5b4fd3fef2c141113342455c16248c9ab78beb4c004388af51d"
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