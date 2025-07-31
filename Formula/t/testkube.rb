class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6b78fd5e7b18e04ec88d538a6590a2c2fadf17979a3c39180193e420fa4bd776"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754376896d8934045a87c114806db1bf0f8440d788c35ab005e9cfca17e68589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "754376896d8934045a87c114806db1bf0f8440d788c35ab005e9cfca17e68589"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "754376896d8934045a87c114806db1bf0f8440d788c35ab005e9cfca17e68589"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e7264bb3b833c4f34d41d7ff3b50e21422398d84c875acf668c18ed6c2d657a"
    sha256 cellar: :any_skip_relocation, ventura:       "0e7264bb3b833c4f34d41d7ff3b50e21422398d84c875acf668c18ed6c2d657a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2fbb1a5fe6642892258946601c9b61d814e9024fa19c49f4280960a3058fe48"
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