class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "3526b8ac839732d6140b94b75e747a48283bd0ebf68072b306eeda6def9e59f4"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae1527030bed026a0e8c917525f155d40ac2c2c1f0ab7b5da1f87f454875e293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae1527030bed026a0e8c917525f155d40ac2c2c1f0ab7b5da1f87f454875e293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae1527030bed026a0e8c917525f155d40ac2c2c1f0ab7b5da1f87f454875e293"
    sha256 cellar: :any_skip_relocation, sonoma:        "28a578d54af34464e3290fb259c400f21fb22389de3da2c00aceb85a09decccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9546c86fd9b577ec0d43d404afc8e9271d8120edb31b1ba43acfd22e6bae71cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "357f80c5bb6ddbc0bf66d0b7b5a02d4a076893cf19db0ca901f2bd619a71e9ea"
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