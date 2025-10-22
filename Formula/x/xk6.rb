class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "a901215215836e3a22e9f9b828550a51e1c4e7690de79b53131cb4f9ecc5b8d0"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "384558572eb2329b65c7576ed9f87eb6fa36036b53ba09dfd05d4bc0e88163c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "384558572eb2329b65c7576ed9f87eb6fa36036b53ba09dfd05d4bc0e88163c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "384558572eb2329b65c7576ed9f87eb6fa36036b53ba09dfd05d4bc0e88163c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f849dfcaa93d0eeace38db3a48680f4cd0499d3db727b450ef3f62ad89611acb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "450338752344057561d3b9eee87b97da26cf3e71158a76bde264989a8e304e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6acdf056c68992d4d8417994d84fe4a891b058a4c8b75ae49e32582c711a0d73"
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