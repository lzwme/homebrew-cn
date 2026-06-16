class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://ghfast.top/https://github.com/containerd/nerdctl/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "dcff7c99d2628fe441917712341da12db342aae16cadde6fa51be5f722f087ba"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "21b3b14b4024fb37a22886bff290f19e011db864d2e70a8e8f7c4e4124a35e3d"
    sha256 cellar: :any,                 x86_64_linux: "ae31969eb88f74bf0ea3f6b1affd5833bbe03c59289fd424b6f804b1e01fbf39"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/v#{version.major}/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdctl"
    bin.install Dir["extras/rootless/*"]
    doc.install Dir["docs/*"]

    generate_completions_from_executable(bin/"nerdctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end