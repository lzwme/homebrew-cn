class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "32b6b7c5cdea86cf59b909d0a2be47a00b37cbef3e242842f4eb6aacf7b28fac"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00c3283b257440c4d7ab1bfa8d872d199f4dbd7d330be2675ae7e117218b55a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00c3283b257440c4d7ab1bfa8d872d199f4dbd7d330be2675ae7e117218b55a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00c3283b257440c4d7ab1bfa8d872d199f4dbd7d330be2675ae7e117218b55a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc94746c2b56a5a9f7dfa43b3345e0d35f99557bcab622890d5d9773d49139cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b2275b0811778e3fb444be87582f382aa5fb872e4a31a75c2a6e7ea34d632bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b288f4c6442ec7613f2eae53d9d8a66f3d06db7b3707df10ad42e944b055cb8"
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