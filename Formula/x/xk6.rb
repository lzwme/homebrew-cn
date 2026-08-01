class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "faaa6de8f3f03b32bfb947f367216aaaad950307e7b45cf4fba90df5f2c08f5b"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "684e076a7dee6c2a1eca7f08fbf52fb882a5a70e7d34f308d6517b03d13f5aad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "684e076a7dee6c2a1eca7f08fbf52fb882a5a70e7d34f308d6517b03d13f5aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "684e076a7dee6c2a1eca7f08fbf52fb882a5a70e7d34f308d6517b03d13f5aad"
    sha256 cellar: :any_skip_relocation, sonoma:        "5159b7a21a518e7849659105620dfaaa46d97d2cd823e98394028a35d8b841f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d825fc06fcc20792f86b96f8a55f48a7a2989458f3ec77466d208fc67b5e3875"
    sha256 cellar: :any,                 x86_64_linux:  "e808d5fc31604cd09df3355c29914c2a2fea4857bab459f478c5ad050f7411c1"
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