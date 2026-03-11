class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.7.1.tar.gz"
  sha256 "453e77c18df8925331aae7c134bfd4960fe0dd6c80654f18fc27ce1f68cb9dd8"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ad3c3ee26f10f091466e436b80e43b69cc29fc136cdc5e9a5fdac4426a8ab4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c89fd281ada8a7c6c86384220537393e27e44f04b8f36c142d74fbe6c047f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c16521ba56b0b552f6b2832b103f0c96bbd2d6ac77537b63a4ed6e41a87138d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0e3618644f18d689c78a849a9de255011cb883fd3c426b2c57d370fb9a500c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd75882cf21aa7609822297d8e30413b8689bbb38bd4e0237c6c9a04ad71dca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e52bd6c267badf1bd541fb7a7982569fb77cc81f299a6fb67d649574d00e0275"
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