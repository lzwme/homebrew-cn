class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https:www.kubewarden.io"
  url "https:github.comkubewardenkwctlarchiverefstagsv1.18.0.tar.gz"
  sha256 "315fd4f31cd02c196c4c85a00854fbfce292ab1a3ffdf323a5ea168620c100ff"
  license "Apache-2.0"
  head "https:github.comkubewardenkwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963b0b043bc3391097b8a70e43cdd0d3a3bb424f2b256c5321df7066fb09e2ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "116decc55e886cc5d8e73076573e0323c88324a326390f7d443e8bb31f33da2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b05edd54aff2590372d7060d56edaad94363dadecd6aea54f83c8228d026121"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ab48946cc90231a382ee596defb02f0f9ca523757760f098f4ba5ad39ea66a"
    sha256 cellar: :any_skip_relocation, ventura:       "25f84b3ed965cc5140e61208b04718a74800d77b2d0f4cb337cad305e394c711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49980de56abaf5e1f1896289a084fefd2b0f7fdc38dcb339ecfbf8123a5b5c5b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
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

    (testpath"ingress.json").write <<~EOS
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
    EOS
    (testpath"policy-settings.json").write <<~EOS
      {
        "denied_labels": [
          "owner"
        ]
      }
    EOS

    output = shell_output(
      "#{bin}kwctl run " \
      "registry:#{test_policy} " \
      "--request-path #{testpath}ingress.json " \
      "--settings-path #{testpath}policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end