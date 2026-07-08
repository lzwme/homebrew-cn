class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.11.1.tar.gz"
  sha256 "699b87ecdeac4163c407297b60066cc7fdcc93a87e0ca31260d74ccfbba26d8c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1199a82a865058c2f4f114d88bdf46c27c6d05dbb3abcb3a2f04653a07ce5bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85ab8e36c69018f7b97afd0246d679f708bf7818ea0eb7d04a4282d7b2ee79a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a5b5e133072b85292577d80bbb6d6376587feebaee9eb112548e6ea71387af"
    sha256 cellar: :any_skip_relocation, sonoma:        "f42f5816c4ec7e2a17df268f385fca3406115d775cd5d0b1ec0a1de63be98965"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6a5adc0a7588977350e5447f54f0945f9624b0b0ca54606ecc85f68f01f7394"
    sha256 cellar: :any,                 x86_64_linux:  "70fcbfca7045f6bff34ab8243d30f36580ed8e261547ec9ba93276f321ddd8fa"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end