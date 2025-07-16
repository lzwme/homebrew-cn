class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b70efb7927bf296962535a18b806ba1587e7fda9b12711b4410652e655da5645"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e71c9e30ee8d0ff746dac4bb91cedaaf0626038c343fd9e2b33e0311651e63b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e71c9e30ee8d0ff746dac4bb91cedaaf0626038c343fd9e2b33e0311651e63b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e71c9e30ee8d0ff746dac4bb91cedaaf0626038c343fd9e2b33e0311651e63b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1916c168a0461872a08fe1937d5880538c708e0c8b8b4e150b4456a8c7cdcdb1"
    sha256 cellar: :any_skip_relocation, ventura:       "1916c168a0461872a08fe1937d5880538c708e0c8b8b4e150b4456a8c7cdcdb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48e4d1e6bf734ca0a383271861d3d083b5fb99f9ac13b64cf5a2ac08390fdf03"
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