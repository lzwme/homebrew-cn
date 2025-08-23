class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "77327530e6b8a08a7b56460d6bc695823985da58fe0e5b37321a482c05538359"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95cb511a4d2f2835a3ca1f364fa707b1c3d30af1625df0cf01230d353d9e6fb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95cb511a4d2f2835a3ca1f364fa707b1c3d30af1625df0cf01230d353d9e6fb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95cb511a4d2f2835a3ca1f364fa707b1c3d30af1625df0cf01230d353d9e6fb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9b6000fb435b74bb15bc2879087d10c91fdf82449c79eb01228cc51a9923511"
    sha256 cellar: :any_skip_relocation, ventura:       "b9b6000fb435b74bb15bc2879087d10c91fdf82449c79eb01228cc51a9923511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c056c024ab43b23523684d7ffab9805a62b05534a374ce305afb0ae54c45774f"
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