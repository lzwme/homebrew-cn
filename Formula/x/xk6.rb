class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "63498eb8136f8a2720928b413dd764710bd223530be77ef9bce6b374fe3eefe9"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "107ee38d73dbeba68ca8f170ef838a659d690fd7c1d3921ac38535b0fe369932"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "107ee38d73dbeba68ca8f170ef838a659d690fd7c1d3921ac38535b0fe369932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "107ee38d73dbeba68ca8f170ef838a659d690fd7c1d3921ac38535b0fe369932"
    sha256 cellar: :any_skip_relocation, sonoma:        "39a72bccd8d3983ed86f81d9c4d9d43e9ef26e75f908d8acaa5e91d2ee514dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a96441e8208f494b361d66e786d44cb2676e65acdf22e38867117a610d54ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07e34e11095ac342777ab1ee317acbb13384eca4c87d9ebfcbd58256b787883c"
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