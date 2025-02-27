class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.99.tar.gz"
  sha256 "376b9d57c9c609a7685db73309edb5162ec9b0f7957d042dcdb5e4b5d1e93210"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f8f28bf1062ad18ac76a326dc066919e482d8e6904b36418e6c34c2ab908301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f8f28bf1062ad18ac76a326dc066919e482d8e6904b36418e6c34c2ab908301"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f8f28bf1062ad18ac76a326dc066919e482d8e6904b36418e6c34c2ab908301"
    sha256 cellar: :any_skip_relocation, sonoma:        "93f226fe956bd0d3d0365bec14ebff77a2fe39e98999f93338e9cdb711208002"
    sha256 cellar: :any_skip_relocation, ventura:       "93f226fe956bd0d3d0365bec14ebff77a2fe39e98999f93338e9cdb711208002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5813cae68398c383c04fdfcd9d91ba0d65320959cdb643e125a649e27bac477a"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
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