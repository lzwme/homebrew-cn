class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/releases/download/v1.4.10/xk6_1.4.10_source.tar.gz"
  sha256 "299021e3471820d27815f8699e9467491e8bf47f45f86207b387f1808324988b"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a31b6347454534b846f11c8703830a6c3dbc7af070804c4c13b6f7cfc1185577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a31b6347454534b846f11c8703830a6c3dbc7af070804c4c13b6f7cfc1185577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a31b6347454534b846f11c8703830a6c3dbc7af070804c4c13b6f7cfc1185577"
    sha256 cellar: :any_skip_relocation, sonoma:        "893568f188a38fd1891367b35489f978be5377922a99a58105579a337e75bc68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fccad995e910b453ab1a3086b11a2c0afaef5bedb0f890bec5b73c73f19b9a60"
    sha256 cellar: :any,                 x86_64_linux:  "4978378f090c62172b2d8d0accc2774223fcb815dec1da8cc1f641027a242cca"
  end

  depends_on "go"
  depends_on "gosec"
  depends_on "govulncheck"

  def install
    system "go", "build", *std_go_args(ldflags: "-X go.k6.io/xk6/internal/cmd.version=#{version}")
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

      lint_output = shell_output("#{bin}/xk6 lint --disable=vulnerability")
      assert_match "✔ security", lint_output
      assert_match "✔ build", lint_output
    end
  end
end