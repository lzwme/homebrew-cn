class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghproxy.com/https://github.com/kyma-project/cli/archive/2.13.2.tar.gz"
  sha256 "9bd36f95b45d23dd5f8de310700c7b2696040db30a59878640e43f0789d0e728"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1212d3c3a2d614e2e42e119d9050e8066f6f7680abf77ace87065edabb1d5c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01713c2fa6455d6708105693e943d518c0570a76a0fdd26f676afede1f989af7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa75591a6657f830f07c4e911ae2988c4ca7e32c41c9f6987f59f9b3bc7ee135"
    sha256 cellar: :any_skip_relocation, ventura:        "0e1fdbe7eabe8a899cdcf0f68d887646ae1a1d8103804ea9842cb5d2be4a22bc"
    sha256 cellar: :any_skip_relocation, monterey:       "9e3f143eb1d0d2f3c406f790c145c54a60559d808c25b43b70465af2e3d038f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "af32bbd9ae65b7a2e03127220a3c71e25673b311cb3951d39b81785a40df87a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc0741ab98badbb04008f28843306a70cb58258618d15da998507a58842dc892"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end