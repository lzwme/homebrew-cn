class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.12",
      revision: "472c6a0f828841ab8c20959bf0fe72df2d6f2093"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8d39d1e3ffa32248d890c4669d7be88291469b3bf52adc52ef6b6e60044231c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04bc236a3b782a7cde24091ba5597aacca2278f1dc526506922442c5092e26d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cd3d029a1dffe04bbb992da960ade6646a68c1ec6e986139afd4602e55027a7"
    sha256 cellar: :any_skip_relocation, ventura:        "d7c8ef4b4f2c3c992241fc12a4930f6f202f514cce1355dab79399ac37cea8fa"
    sha256 cellar: :any_skip_relocation, monterey:       "e5a2b589918588357aead8017d853d8051ed6548c8c96696f60255cfced7fc6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f24ebd1295e3368e89a2052377427994f83b71827f62cec82179656e2354ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "536780890bf342762fd20335a872a0ba2f5807c7c1aaececc230fe4a89c27caf"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"

    generate_completions_from_executable(bin/"argocd-autopilot", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end