class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https:www.kubewarden.io"
  url "https:github.comkubewardenkwctlarchiverefstagsv1.21.0.tar.gz"
  sha256 "0e6fe9febad18956a0138fb56905c78bac14c1b2d72838901447d5dde94e186f"
  license "Apache-2.0"
  head "https:github.comkubewardenkwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a98492f79b3cc0745a8df64b8368f5477a869881d8168435e159d4a23460b7dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74ec5bacf18a39bfb089291d665105b7e649170d0b218759d190535846dae3e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c61e9bbcc2a659200e29f1d4d25ccdc7c8d72348470fff3a7f2fec03d7a35ec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c017a10aaeaffdc6ff216c2bc80c9ec3341fdb987f41150ce9c5138cf439906"
    sha256 cellar: :any_skip_relocation, ventura:       "1b5563240964a1c791b7adc7d4fa27695f2c29d98c076e7a12a8cbc8f56b01d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7673790602e7f5d2992819259aa8ba87a8684cc37131a0a9798176f783d00833"
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