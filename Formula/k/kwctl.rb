class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https:www.kubewarden.io"
  url "https:github.comkubewardenkwctlarchiverefstagsv1.15.0.tar.gz"
  sha256 "4228e5021f90e4c2d8e1a71ac8ac79f6c37b2b8f42f63da4856b69b95d9f5dee"
  license "Apache-2.0"
  head "https:github.comkubewardenkwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20acd63b8c1d7f7bf4100e1eac183c901c1fde0d72f5c75c790fd2f76e529a63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df45ec5a9fe533433a1e9f37b593ed59320d3601e5c6eff70ff08464f6479ad7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecad163b4343982b847f3e36dba27636075d52b9efd9f088e1cfca422ff53b96"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cbed6e7e0b4393d3752e9380f1f6aad9433793fc16b66237b4297dd316876d6"
    sha256 cellar: :any_skip_relocation, ventura:        "9212d11e4b84ddbf71f14c03b9218dbd73b2d8aef269a3bddb18ca30c662616d"
    sha256 cellar: :any_skip_relocation, monterey:       "a0347ee0a90dff70e10882d8a046318243a10f699a32350413118158d28e6640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89380e5657e5582c0c800958da5446b1492eeed17df85c9ea791627d0420bb79"
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