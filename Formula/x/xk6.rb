class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "e89a199ff1ab9ccb1b3ebb671ac46fbf37ea567f3e1795b4b8aadf0d7ad1febb"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ab9a628fa0c6ecd97c4aff87c393c466f8afd6f7a5242017f01ba34eb2639db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ab9a628fa0c6ecd97c4aff87c393c466f8afd6f7a5242017f01ba34eb2639db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ab9a628fa0c6ecd97c4aff87c393c466f8afd6f7a5242017f01ba34eb2639db"
    sha256 cellar: :any_skip_relocation, sonoma:        "7856601da8a3b4d943d1fe05b81c78fc3dec98788e349783e82cb830c2b558ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c51afeac7b9651bde8c4d2cfa08e997d21a2700bbcc90c34e76d2a07cc68f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64d0a3290ef986ff384ca9f7b66e20083ae419bc36dec25e5c029ea0398561aa"
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