class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "18c0d3996eb3ed905cee946f746c738cde425d48e3bdb488da1df3236cdaabb5"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e568cced21dc1bf9fb0f6d7ea5cef759f30716175b66f25da8298ef9c25dc8db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e568cced21dc1bf9fb0f6d7ea5cef759f30716175b66f25da8298ef9c25dc8db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e568cced21dc1bf9fb0f6d7ea5cef759f30716175b66f25da8298ef9c25dc8db"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffd9fb6ecd9f091fd0da82fdb2a549b2034af1f06e4534f256a1bac46abaad29"
    sha256 cellar: :any_skip_relocation, ventura:       "ffd9fb6ecd9f091fd0da82fdb2a549b2034af1f06e4534f256a1bac46abaad29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68c98fd5849c0258cad4a18173059ecd3006d91ac2bf295ddc939981d5d2944e"
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