class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "0325c267631c564f21aa6e7924647204d2a6562552310070e3581b2a34bf25fe"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beb64fa0e1a2512f668fa08dc0b842725a0ac702f2d4bdbb794f045c89a41349"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb64fa0e1a2512f668fa08dc0b842725a0ac702f2d4bdbb794f045c89a41349"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "beb64fa0e1a2512f668fa08dc0b842725a0ac702f2d4bdbb794f045c89a41349"
    sha256 cellar: :any_skip_relocation, sonoma:        "019b86d740b669c6620b8eff55da2553b953b68ceadad8b26ad8dcb89a61d3a0"
    sha256 cellar: :any_skip_relocation, ventura:       "019b86d740b669c6620b8eff55da2553b953b68ceadad8b26ad8dcb89a61d3a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e36bca0aad516d86869c001b61f8442dd401efa99c2644a33b09bfa4ebeb0e7"
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