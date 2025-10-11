class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://ghfast.top/https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "4372fa39ab82903d09fa22a1d2f03fe2a1f6fa1d1f7643759d5bb937ad876bd3"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6a4debaf398d6943cedc23d19cd6e4dbafdf3c17e7d447032af9a5af8350572"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6a4debaf398d6943cedc23d19cd6e4dbafdf3c17e7d447032af9a5af8350572"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6a4debaf398d6943cedc23d19cd6e4dbafdf3c17e7d447032af9a5af8350572"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb968189a169ed27b4dbba1aa69b9ddceeaf60d62da48998dfa1c548f9d2f6e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74e008027e4e44d19166e22b553df189e59af87615ca309cb973baa174887fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aac3aecd30195ce5e7744211c2a037b73d955221d4af87d420396b5e36dad7d"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end