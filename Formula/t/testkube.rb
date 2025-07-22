class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.164.tar.gz"
  sha256 "4f0a6c78c456748f7fee1745c9fb3ddf9b2c701784805be370b1edf21af985c4"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0626eaeab694ef94977fd5ba238bbe00bf01e6484f7177745b1c6895fec4ad25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0626eaeab694ef94977fd5ba238bbe00bf01e6484f7177745b1c6895fec4ad25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0626eaeab694ef94977fd5ba238bbe00bf01e6484f7177745b1c6895fec4ad25"
    sha256 cellar: :any_skip_relocation, sonoma:        "a91d422e054b0c961b942f3ff2bb8984306ed062d794989a94953bdbfeb9ad9d"
    sha256 cellar: :any_skip_relocation, ventura:       "a91d422e054b0c961b942f3ff2bb8984306ed062d794989a94953bdbfeb9ad9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea02ac29f0417b9682f0555b6d8b04b2b16d34dabbe9da3f271be110208c2b3"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end