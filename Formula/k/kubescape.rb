class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.13",
      revision: "79734b8bcad5ba4265cd4046a4e42e218adadf8b"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98a200549a8df942b8b0f3ea2e95e54591b3260aef74e9010aa618c8191f2742"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5c93ce304cb0db7775c1d0c0de56f4e1103ea6fc1ef829b633bba022a7587d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83f0e46830ad95de36945e85fd0397ba97c1db0ad580abcc67e4a2a46cba2ded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ec9888d8cc424f4765c013039275fc4b577db035c0ae186fdf5273d6cc6dde9"
    sha256 cellar: :any,                 x86_64_linux:  "acd5080e274e7112b7dba58fc0a96cda2f15fa9871d3c8bffabdde971a46b3cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra)
  end

  test do
    manifest = "https://ghfast.top/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end