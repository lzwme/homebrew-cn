class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https:www.kubewarden.io"
  url "https:github.comkubewardenkwctlarchiverefstagsv1.19.0.tar.gz"
  sha256 "9de263a3c51a5ffa8e468938a5fbd31c4e7174c583cbdced4839d847e93d2f4f"
  license "Apache-2.0"
  head "https:github.comkubewardenkwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74b1b2ae56157465a59b3120ac8941a1d6967826af111cb70f51465d2ddaa593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c633f7f9b2dd8270f4e5147a8a5a77ad6eb82295b3d8e6c0613aca37820d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e60536652477f5b184685415c588e5f4139ed2ab0b04f7dda1236152b6c2bfce"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c601b6cc413ddefed9254dc2722a0470fdb88079b6210a9f0545d112420a6ad"
    sha256 cellar: :any_skip_relocation, ventura:       "71d265af2a3207c8d9649e02e81c2bc5fd7f171ccfa607fd84da8333fe7cb5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff66ffcf550db2a2ad0b89df9589762e44848f872d7d6bd177e1f527b42e832"
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