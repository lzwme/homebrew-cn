class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "77f8f154a14f74d41f91e85e142279c480c5d7098207f2706ed1cec3ae13ea60"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a797f3c1a99ba3a230574804bbe47a6eda1f06def1006e3f15608773ed3dcb02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a797f3c1a99ba3a230574804bbe47a6eda1f06def1006e3f15608773ed3dcb02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a797f3c1a99ba3a230574804bbe47a6eda1f06def1006e3f15608773ed3dcb02"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee894bcfd4b034740cd3f33dd8f87a99ba0328a5c0c96a780bb56241d09c0844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce77d73e452d0c757b52f26908e1640dc1686dbfbb9278fae5d80d0340be6900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bd2b1abd535394ea333ad1b4576d47d97d6c798ab9e0dbfee6cd24910f36893"
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