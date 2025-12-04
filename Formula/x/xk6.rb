class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "02d1e5ed9b611ebe4d80545af2b3ceecc3d095225acc3e4752beca8d76516349"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b41bfa0584d0e4926d8523951a60f3d210a13f359a676f1c021e4ed4b6618937"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b41bfa0584d0e4926d8523951a60f3d210a13f359a676f1c021e4ed4b6618937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b41bfa0584d0e4926d8523951a60f3d210a13f359a676f1c021e4ed4b6618937"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5e892ac5def885dba60fcb89b257a4bbb5e11e2f5fad3e43d9f09b159c06705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfb1d5b9855d482ae71b446dc7fc0490beb17428359e2eacf1414d2ee623ab61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708a8a8d4159563c37dda38112adca7c2317b88523049a55b073c18d90c85d6f"
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