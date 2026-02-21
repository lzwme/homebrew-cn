class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "625bcee9d2e291ced699c34b509b65a48623cf02fe09a306dd40bb1beaa9d9ac"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5e4f29edaa56d4e68014fbe32bd128d8f4d7b6c45833a4a182cd19407c7b952"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5e4f29edaa56d4e68014fbe32bd128d8f4d7b6c45833a4a182cd19407c7b952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5e4f29edaa56d4e68014fbe32bd128d8f4d7b6c45833a4a182cd19407c7b952"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab968ea60b6927cfd6d8fb874582bcf3fb321ea29bd36f2c1f7ed535b989b9bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b52b18531551594451e3a06b210db99802c901a5718e39e6a8b4bb4a25e8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c783131b85770ec363bdc7bb743a154b0353c450088b647277bbcd7bdabb0f"
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