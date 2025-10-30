class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://ghfast.top/https://github.com/kubewarden/kwctl/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "d69e014c1e9c51f425bef8f12b5c70d5cf2e5d4aa920a5d69ed9186a6abdf8be"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d814d6f6c64dae69aed003eedbe69acc94d44871ebfb93cc7af58f05843b9111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a4eae7d06223e98f838f97ada20392c1dbcd7bce6e65e7c2a6fd92667d20309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eeaa3adcf3dd41a82604e66020c17111ab5d4189d142f77b88d304dc6894dc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b246029337202238c2d1b4b327ab010bc049b6c70c51deb2ad48699da996e7e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee9f10b25e0a9fed1c7a3ce1a087d615996386f3578e5372d35abb4876687a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d4343ccbfae883f400969196f88daedf7952cf277f6f5ec30b3c3947b4f30e9"
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