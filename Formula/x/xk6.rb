class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "e832c6d8edcc02e3942c2c6c2f0f1af3ec129f072e91a16d4a583ab099a4c667"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f20f269f643c75d58d90302df330031d210444fe621277468dfde293cb8ee35c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f20f269f643c75d58d90302df330031d210444fe621277468dfde293cb8ee35c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f20f269f643c75d58d90302df330031d210444fe621277468dfde293cb8ee35c"
    sha256 cellar: :any_skip_relocation, sonoma:        "06baa5d3fca37f2a07493973f379308227dbe46d3aa5f8da54fee8403722293f"
    sha256 cellar: :any_skip_relocation, ventura:       "06baa5d3fca37f2a07493973f379308227dbe46d3aa5f8da54fee8403722293f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3c178d9ccbc611d62de87d69236e1d040483c43bc1507da894e2a0cb658332e"
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