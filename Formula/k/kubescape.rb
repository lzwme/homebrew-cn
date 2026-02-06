class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.0",
      revision: "cfe022ff1d3488415405711513ee993684696ad9"

  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68e44b88f7fca278e0ed085e7032031d4b6f0965b72c6cc16a25eb744e4b23ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6105f3c4247ccaefffba7eb1d229276ff0abd175482399f2c0000a97f59ec35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68aa3a7aef9dc56fc23a73d15ed9392c6b380aeb87656d2e8e8ecd816ec2f4bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf9c50a60455b75b9b38e5851c63753e052b2f276456b9d39ec4afd04847c173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "263e12d92c172a26a69e5d9d83f52126f7039d90d8c24a07a0354866755fb02b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a789a4f515321d06c344bf050b5475cfc90f5f1faf28fd4e5bfd921b089fb825"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra,
                                                          shells:                 [:bash, :zsh, :fish, :pwsh])
  end

  test do
    manifest = "https://ghfast.top/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end