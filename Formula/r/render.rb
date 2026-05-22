class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "9e34fb095b4f960ad62593a66d1511ab46db525780a9abbd737db03e34a2a29d"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92f449185926034d22c57960c3b6947f4ad9d43eae2717c5494b04fb59f0276"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92f449185926034d22c57960c3b6947f4ad9d43eae2717c5494b04fb59f0276"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92f449185926034d22c57960c3b6947f4ad9d43eae2717c5494b04fb59f0276"
    sha256 cellar: :any_skip_relocation, sonoma:        "412c5af3b07ce2d950c8d789c7065838dc8822e24f33bea93c2101b97365e46b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f21e1fd392a4334f108d83dac2e25fb01ef892301d48f1586b696bdfe2ed5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9bd24c0fa082d9f40f6115e5f0121919657d7045214eb4d2b5040ec625b75e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end