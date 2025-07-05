class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.161.tar.gz"
  sha256 "59d7a02c907d6f22476f360a21d98c999ed2bef0f2b822ec129fe36d5d2718c5"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f67c3a58a4c323e2731c70290a193dd8b9dab6b0bc985255cbbd1bd3e312a83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f67c3a58a4c323e2731c70290a193dd8b9dab6b0bc985255cbbd1bd3e312a83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f67c3a58a4c323e2731c70290a193dd8b9dab6b0bc985255cbbd1bd3e312a83"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd07c592ce85ec0c45305aa2117ab87846eb84e982fa7603225c10d185d1e5bb"
    sha256 cellar: :any_skip_relocation, ventura:       "bd07c592ce85ec0c45305aa2117ab87846eb84e982fa7603225c10d185d1e5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb93d1d65e115b70dcf1a2d0af98de6861b8b5ed27f3912b13b78c24d5dafbdd"
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