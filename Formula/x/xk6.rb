class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "3be2efbb757a3e65d3fa6e04352122cb6851e3f34861191c0bbc0b1add7d5780"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a62610d739068ec84cb0ffc44267d708cc5e16c03de29844f21412fccafbabf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a62610d739068ec84cb0ffc44267d708cc5e16c03de29844f21412fccafbabf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a62610d739068ec84cb0ffc44267d708cc5e16c03de29844f21412fccafbabf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dfc272f16de090b00471f786c87e5509b33fdd2d89553a9ae95340d5a369b8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ddf1f4f52c67be7b5c3e6fc7e279254ebd0e2d69f0983581a2bc4a7a7e52303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f521ad53bfec5658e80f4688f7136ac5d3dec516ffcfbb3e26f4b1daa002ca5"
  end

  depends_on "go"
  depends_on "gosec"
  depends_on "govulncheck"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X go.k6.io/xk6/internal/cmd.version=#{version}")
  end

  test do
    assert_match "xk6 version #{version}", shell_output("#{bin}/xk6 version")
    assert_match "xk6 has now produced a new k6 binary", shell_output("#{bin}/xk6 build")
    system bin/"xk6", "new", "github.com/grafana/xk6-testing"
    chdir "xk6-testing" do
      lint_output = shell_output("#{bin}/xk6 lint")
      assert_match "✔ security", lint_output
      assert_match "✔ vulnerability", lint_output
    end
  end
end