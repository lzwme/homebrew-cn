class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://ghfast.top/https://github.com/kubewarden/kwctl/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "bd45494d611746633c090db5c7e7dc8fce5d1f685f606b74c2eb1515e367525d"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55b6098d8865319803dd508afa8d36c58b7ebd6716a0fd615b9d6501b76ff3ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66b1e784f1739c6b1a698802c286e4c77e93803dcd44174b5df6ad830619ef63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "839660f65e947d3001be4cfb9b956eb0a3b728c898c392f9f9532f1b1d8a95e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "623edbd8c0d44aa6628513750f3fc8524940a469551c1ab6fabefd19ed2160c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ae880a0e890b081278b0474e16d74394e242d764c9c2a55452235f37f9b772c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03aecf5420536463bc737554552fe14d528500f01fe4347b5d906829d0dc1efd"
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