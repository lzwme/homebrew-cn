class Nyan < Formula
  desc "Colorizing `cat` command with syntax highlighting"
  homepage "https://github.com/toshimaru/nyan"
  url "https://ghfast.top/https://github.com/toshimaru/nyan/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "0df7b5b25f71da2ab5458d3bf9a4d0158bea1a9a6f365937cf3653f9411150eb"
  license "MIT"
  head "https://github.com/toshimaru/nyan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85ec2874fa41b2db68fa86d2e830bdad8cc8876984e66ce2b2a8fbbf7177f98f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85ec2874fa41b2db68fa86d2e830bdad8cc8876984e66ce2b2a8fbbf7177f98f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85ec2874fa41b2db68fa86d2e830bdad8cc8876984e66ce2b2a8fbbf7177f98f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5d13e720cd69066895046f71d4002e94f8d01937254700fb5046320e8e1e73d"
    sha256 cellar: :any_skip_relocation, ventura:       "f5d13e720cd69066895046f71d4002e94f8d01937254700fb5046320e8e1e73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d71ae6d69044a2e3c7a02f5a5fb9d040dafe372c6f0e7d1f709030ff5bc40205"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/toshimaru/nyan/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nyan --version")
    (testpath/"test.txt").write "nyan is a colourful cat."
    assert_match "nyan is a colourful cat.", shell_output("#{bin}/nyan test.txt")
  end
end