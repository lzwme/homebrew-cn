class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/releases/download/v1.4.12/xk6_1.4.12_source.tar.gz"
  sha256 "cecf07a18f6ae981360bbbb4fb24439467049093d838a9cddd9602d23cc7491b"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd85df82ac7b647e3225f8dca1994586944a1e7fba71e8754b094a96a8fa3b2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd85df82ac7b647e3225f8dca1994586944a1e7fba71e8754b094a96a8fa3b2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd85df82ac7b647e3225f8dca1994586944a1e7fba71e8754b094a96a8fa3b2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdbed708ff9b44e55266990675c409dc7405482cc9d4b4248e4acaee1c8f71e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ed75f25a62ffe82b890e6ec2cb4f4611e660050930f7a01a2fa2dccbe13618c"
    sha256 cellar: :any,                 x86_64_linux:  "b1e549e9aae181f22ff272b61b5df1e0786238e28985b7716c3ba5108781c488"
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