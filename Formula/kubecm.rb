class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://ghproxy.com/https://github.com/sunny0826/kubecm/archive/v0.22.0.tar.gz"
  sha256 "80173b119e2c17e13857d790a466757bb53b0fad9b700be2bf7fb64086755228"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "047e82922986ead98ec56a1047e57f1c1b3ba9c5b8af2fb03405042e3bf0e4ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3beaa86a8b67bbe916c9126c73425c8c214d4b783f049a5ee9bfb81ddc4faa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3beaa86a8b67bbe916c9126c73425c8c214d4b783f049a5ee9bfb81ddc4faa3"
    sha256 cellar: :any_skip_relocation, ventura:        "8467fe8c9ab32d0cf45d0ceadc23dd2fc7ab52ece0c023c554f9937ccbcf67a3"
    sha256 cellar: :any_skip_relocation, monterey:       "8467fe8c9ab32d0cf45d0ceadc23dd2fc7ab52ece0c023c554f9937ccbcf67a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8467fe8c9ab32d0cf45d0ceadc23dd2fc7ab52ece0c023c554f9937ccbcf67a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb9da2953a4803c3b3d7c1c11cd90169e10660df7cd45cb445517f0939780b4c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end