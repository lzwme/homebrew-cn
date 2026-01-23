class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://ghfast.top/https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "8e160f6987406c8ab08230993c10d675775e26bfddaf4ebb456bad32b5ff20ad"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "766ad53520437a8aba893a1f6d3671eb60c885f39888ce2b397ce401d0b2ac8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "766ad53520437a8aba893a1f6d3671eb60c885f39888ce2b397ce401d0b2ac8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "766ad53520437a8aba893a1f6d3671eb60c885f39888ce2b397ce401d0b2ac8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dba3d5e518a346c71b26349c877f42894c084236091b72dade84107171bcfd9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea9c42dda6306afbe48bb2e105d2a1ce61ebc3e80fb5d545b31cfafea1cde0d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d08a55740324ccd4426f421f6258e82f11a4f0f9c843f99ac7738a9b91052eb"
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