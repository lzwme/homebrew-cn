class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://ghfast.top/https://github.com/kubewarden/adm-controller/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "70548acbd8415eaa37b3900b673deb733d5380899b6cb0fd89e2861593d170a6"
  license "Apache-2.0"
  head "https://github.com/kubewarden/adm-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1e3277a01fbad7cc0367b70f5bdd018f31cf08129b699acdafc93ff5fada495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6adaf51f90f0827f26eaa77e02a240cc1ee8705c43e64614e2e7ae70b57c663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef05b2287703178ef08570c078b007bba36e1a59ac72982fa21a7e26d502faaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "562699a76636a6047bc351c797803d764b3d19085750019a82039b989d746ea5"
    sha256 cellar: :any,                 arm64_linux:   "5025ab87ec8ad03933b79137cd6570c3702d71c850ea2ef58b9a8058d9698bc2"
    sha256 cellar: :any,                 x86_64_linux:  "6ca95354c214b4faf7d570bfdb2bd28b7ec98d412eb32404be1eaf506c920b5a"
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