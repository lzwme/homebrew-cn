class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https:www.kubewarden.io"
  url "https:github.comkubewardenkwctlarchiverefstagsv1.9.1.tar.gz"
  sha256 "7bf6ee53c3e27117122b5e025421b0fa606eab580197edae0eddf2e063709568"
  license "Apache-2.0"
  head "https:github.comkubewardenkwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3533fc941cc2693cea9ddc0e3326eef09c193ab5dbe8b3e8a0729a3b87ad9e98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "218bf600a52af8f42f181a130f2f9529d564b819143fb02235920944fcafc4ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2b3f7d45767a1d070f7a6791ce9c21fb66b995074f431027bf1819177822d90"
    sha256 cellar: :any_skip_relocation, sonoma:         "203b79d3977b2d7534ee03d5137bca4a76509a96e6b5482c308828eceb483ab6"
    sha256 cellar: :any_skip_relocation, ventura:        "6082fa69234725fd16171fcef80117e5e25e2309bac1b07b0023c72a12386806"
    sha256 cellar: :any_skip_relocation, monterey:       "d9ba9ff519f676f42300739589b9df090850e3d600ae2378c686ad06e3ba7c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eab8770ac621d98b2b1d3b04d4d5d024d04c186a653499602e19bf0551c16735"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_policy = "ghcr.iokubewardenpoliciessafe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}kwctl --version").strip.split("\n")[0]
    system "#{bin}kwctl", "pull", test_policy
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