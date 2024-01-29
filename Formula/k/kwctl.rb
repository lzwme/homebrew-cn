class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https:www.kubewarden.io"
  url "https:github.comkubewardenkwctlarchiverefstagsv1.10.0.tar.gz"
  sha256 "4563a56f871ed942215994bff0183b6adc4ce702638ddb6d80e9077dde7def24"
  license "Apache-2.0"
  head "https:github.comkubewardenkwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2a025a745aee149b2568a66cbb495534ee8945274b79e8a21e3b73d897eca25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56257515c6f86a827d36449afd483a916d25e406aa4bfa49378c478dacf3613e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "522c4213dfa531ec541178bef4b8b28e79b1340b949c6210a5471bfd549c6b1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "da45dbc55bdff7490d155173d19738b2e749743d04b51d6e9b5f5d9221299bb8"
    sha256 cellar: :any_skip_relocation, ventura:        "60468ca50c1695f437e11205de8b7895e00d4e653be868b49432c110c9306eff"
    sha256 cellar: :any_skip_relocation, monterey:       "13eac466cc050453864f0a18f7c8428261de35b16e9eb82a69c32dc6325d40d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3acb2edc72686ce426d72f3484e58a4b2a9ea7a1802f934ab48b40ea13c8b84e"
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