class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "0e4485a7139f4fcfff593772e2a587af7f84cb296eacb1e2865632d94dd20740"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a2dd41b943596ea97cd8f49c47a77720cd3af5675f9a5eb6a80839edd9d9058"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a2dd41b943596ea97cd8f49c47a77720cd3af5675f9a5eb6a80839edd9d9058"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a2dd41b943596ea97cd8f49c47a77720cd3af5675f9a5eb6a80839edd9d9058"
    sha256 cellar: :any_skip_relocation, sonoma:        "47c1abd3c52ba8d0647227a09dbb101d2547d22e46af8f1dd2ff42f53b18ead3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e29bf91905744b5d7bbd7232cd252c984f99e731ade25e754b6e49417f60f3e7"
    sha256 cellar: :any,                 x86_64_linux:  "264ed7f51ed2a05d6aff00662ae1bae6ed5d5b9b88d22e3f94e3a280e0c53b97"
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

      lint_output = shell_output("#{bin}/xk6 lint --disable=vulnerability")
      assert_match "✔ security", lint_output
      assert_match "✔ build", lint_output
    end
  end
end