class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "234a1d1999b9d0d27e26e600e5f1c859850bf497ba958c0e341a3ec861240e49"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8ff25df93531b63613011b93c5e93e758387434eff082c2d84ec956332029a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8ff25df93531b63613011b93c5e93e758387434eff082c2d84ec956332029a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8ff25df93531b63613011b93c5e93e758387434eff082c2d84ec956332029a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "82b6d188f9c9193801744c9aae88ab006da212a1a61cd02ef377c77b14e1b181"
    sha256 cellar: :any_skip_relocation, ventura:       "82b6d188f9c9193801744c9aae88ab006da212a1a61cd02ef377c77b14e1b181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c29b753bf526380f76de157987eaeee1188cfa4b28a7315e0a5d45c8a69967fc"
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