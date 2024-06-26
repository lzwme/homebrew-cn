class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https:www.kubewarden.io"
  url "https:github.comkubewardenkwctlarchiverefstagsv1.14.0.tar.gz"
  sha256 "178a01a14173090180192906543248f3e002985b501387c9d93f979254c26ada"
  license "Apache-2.0"
  head "https:github.comkubewardenkwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "594f2af8665e7d0f3dbcc4fe523e1b6dfe15c07622ee7849f3506db332bcd1dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32ecc789565170b5cd560c9f569ed37270d65740e979b0c1e237bf2d7a2340e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a18bed5194723110781cc22aea91c717a4244a7416ff70e0a2816661e31e15e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4caf9f1b9c057caeb0d701424af25b93ccc6bca34a1507ced682873d5f506e3"
    sha256 cellar: :any_skip_relocation, ventura:        "cb442cc17e29a78873f5a41e60e2fe8d613fc1f6364318c4361bbc4eca38349b"
    sha256 cellar: :any_skip_relocation, monterey:       "888f556dfde97dfbb26d2d75fd26160763300dddbe2b58423e892bebd591d7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2768ec80dffeef1f5baaf7924eb2763231d950e840ce7617476cf5887f552c27"
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