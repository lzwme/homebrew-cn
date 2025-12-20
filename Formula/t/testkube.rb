class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.5.2.tar.gz"
  sha256 "ff1577e95350823e7f7543fdb6285b49fd3fd61bd875a807c03c151f3bdc0c6b"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d140845e93bd656d91ec8b7fc683946024eba597faf06ac8ff7d102fcc80bdd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55db677f0d85df87f98b6284075dc87f0db23f18b657a484822e75b466ef2db4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30cab7190469314bf7e0f7f8db6570e2727fed0f19259025a0a1940a92b1257c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6e375cabc1fe3f50acca0a3284b4668bad5f82b63358bb03ef26a4cba9ec3a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41bea514896b3f6873de14406be125c8a2104a0f4a790ecf470f6b350376c3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c41d5d35912fa43a2b0fdfccbdf0299a7ddd2d96dc01780d4b2690bc7f5e687e"
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
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end