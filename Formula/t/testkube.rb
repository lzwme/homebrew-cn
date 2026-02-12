class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.6.1.tar.gz"
  sha256 "e02e5e03e626d7c56f3e14bac6a27a70d2764446bb26502047a41bb70d8f3057"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b21d4bc6e83518e9f61796b142033cebb05a3ba2218ba465a9d0b759d93e8a7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "233d0dbc19000346627df78290434c80fc2318ea8478c3da5ca722b48fb09c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1a2db9c5a1adcdb2f1b936d7822da32c531398432698775a887893f3e40e813"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eb769feb037c60857c2c32ba2b9ac24c8bd2a465f5fc2bdfb11016207264bb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70feff44140317f2278cece56012a2694793638e10c84bd7406cd4140417e12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "927af5c86991e1c403196c231b5dcff5fcbb7f5f04132a70412b9a9faf951c45"
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