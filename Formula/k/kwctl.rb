class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https:www.kubewarden.io"
  url "https:github.comkubewardenkwctlarchiverefstagsv1.16.1.tar.gz"
  sha256 "62052d7b6a691da0d8d9c731d52eeee4a0487c0efc6e09e9996388d071354b64"
  license "Apache-2.0"
  head "https:github.comkubewardenkwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7bc1bf463961ddb5e43d1c882c78793547f26ea2fd46cab4145ee00dfcf58b37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f62e0067b4a0f43ba12b8ed8ca1814ead7e8c7b5bd83393c9c7216230eb4704b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5bfbf3b8e326d10f2d4bf85cb5b8be7e178e11c15d1acbaf5f9777df6016003"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73cb11228575a059f487e76f0bb5223cf9c101fcb6464f2a4801c2b60107c772"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e2dad9c25e235b476f60cc3a252e9a243f0dd5a41d74e886070c2bb029655c6"
    sha256 cellar: :any_skip_relocation, ventura:        "7661b97874d8b84cf90f1cf8b570ff21c461ca0900cf22b051b94f45b2d1199a"
    sha256 cellar: :any_skip_relocation, monterey:       "8cfbaae8e6312d9d9243f97caec92b4d265a46cd19f17f6624bc52e54e0c8fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb15087d5705074918a5599db801347159390f61776a1907f9ba1212097cac77"
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