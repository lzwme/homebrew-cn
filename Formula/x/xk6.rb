class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "7e3416f23d55a945aee9d3e98980bcc7ecb43149e8d7a7077e484e061e1da6d3"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5bfc63956befd4e825c07643eda1adba06708ee118c03903cd6b6147d5d0a2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5bfc63956befd4e825c07643eda1adba06708ee118c03903cd6b6147d5d0a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5bfc63956befd4e825c07643eda1adba06708ee118c03903cd6b6147d5d0a2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9442f726c6ac7723019262c1507f03a26c37173d6a514b826eba29b9adece3cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "677211ff7da72f00212f4ab6e6f76f6647686f6904f77db8eeb56f3d22de2a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acde0b88f5a920d49367b210ff0f584dca52ba7923e735ca6dfcd50843364ce1"
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
    cd "xk6-testing" do
      system "git", "init"
      system "git", "add", "."
      system "git", "commit", "-m", "init commit"
      system "git", "tag", "v0.0.1"

      lint_output = shell_output("#{bin}/xk6 lint")
      assert_match "✔ security", lint_output
      assert_match "✔ vulnerability", lint_output
    end
  end
end