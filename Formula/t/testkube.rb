class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.24.tar.gz"
  sha256 "936e8cb965fcad7fb0467aec1acc4da1870652116b0784e4a3a12841a9ea0113"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a578ee72078835ce39df1f3db8cf0faddb468376ad432b4a10a588f4562b0e52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1d8e4c4f113405bdf435d4bce5f9b14e18506b2a063525654bcece5653dea8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a062931236a706dd36ad410a0ca004471e7919138c340fbfee699a2ab6825eec"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1c79cebad5333b707b4b684d117bf7301d2f51c2228ee16dcc080d612bd2031"
    sha256 cellar: :any_skip_relocation, ventura:        "7ac671a82a3f3975e4190735f896646eaad1dafac2dd07acb028a767c405b33f"
    sha256 cellar: :any_skip_relocation, monterey:       "6a9c73a4681fb59aae2849a7bc85eec1826968e6c1b58a75c71f78f815d1e58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65c61af5e659a72834749ba687c588bb5a6852dad10b3bb2a626a84425235ce8"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags:),
      "cmdkubectl-testkubemain.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end