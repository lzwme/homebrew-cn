class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.18.tar.gz"
  sha256 "4c90c92f5fabedfb5eccef0f99f1d5ed3e97471af5d6ce78fe8fa9797a825310"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c849fe478084516385d226e50c8ee1e84cdd1c57b34e2318462e6c2a91735136"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1219ff5f27f91cc1255ca925bf0d3676ff036d47613351eae729f42f71cbf70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2840ca70047f4bcd5fed26794e116fea7da15936350a7e2e2dfa295416c3f2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a41e7f516269a5c66c650dd6339440b2d97bee0ed80cf139f739a7779cbc837d"
    sha256 cellar: :any_skip_relocation, ventura:        "890b2099a6c68f8021d221b33a027f5ec9a7e6aea5c130e9c5cb567d52aa19a7"
    sha256 cellar: :any_skip_relocation, monterey:       "987bfef9d54a623832cbedd9bbbbc30882554644cc886f8e23bb1b424e9b134d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f2e6e7ce3277bbfea1154065b5c3df0564daeca03e0df2d3bf7ab7ac9154db"
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