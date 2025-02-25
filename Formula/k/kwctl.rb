class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https:www.kubewarden.io"
  url "https:github.comkubewardenkwctlarchiverefstagsv1.22.0.tar.gz"
  sha256 "12942bf9bd41b11fcf6dcf36d7be64e77be36664b3909828fed8cb3d165af2b4"
  license "Apache-2.0"
  head "https:github.comkubewardenkwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a30412b673e57ad17f8c4502fba589fba0e5e78feeb289ff7fe6ac62d9684d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95a7855ad220b05b2a2156f09e772a7596b49b17a6c47ff27655c63186a2b27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ae30eaf0871897a6b45416b2a1b422662f2336592190611d2fd2ee322019cbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b51ba2422f84b8e6a52510d422b96cea7fdd144302e63355c2958a671d17695f"
    sha256 cellar: :any_skip_relocation, ventura:       "e9c5b1ed77115d65bdb1f604421aea56b22d73c5170e1b27a59ed90fa40bb765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d95a5404af87aacf8e363b601ef36b1d10c3c890402a5291441a3d2bb1a46d7c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"kwctl", "completions", "--shell")
  end

  test do
    test_policy = "ghcr.iokubewardenpoliciessafe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}kwctl --version").strip.split("\n")[0]
    system bin"kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}kwctl policies")

    (testpath"ingress.json").write <<~JSON
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
          "apiVersion": "networking.k8s.iov1",
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
    (testpath"policy-settings.json").write <<~JSON
      {
        "denied_labels": [
          "owner"
        ]
      }
    JSON

    output = shell_output(
      "#{bin}kwctl run " \
      "registry:#{test_policy} " \
      "--request-path #{testpath}ingress.json " \
      "--settings-path #{testpath}policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end