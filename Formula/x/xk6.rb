class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "79abc84f54c90979a2ef898e47407944da549b82f20920cfcd6190c6b47f55db"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58ba1f0fce905b4698cb987ebd3b83aa585666a854ca4eb94b97edc77b36325d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58ba1f0fce905b4698cb987ebd3b83aa585666a854ca4eb94b97edc77b36325d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58ba1f0fce905b4698cb987ebd3b83aa585666a854ca4eb94b97edc77b36325d"
    sha256 cellar: :any_skip_relocation, sonoma:        "605dabb3f209d268ba7263656054b13be29b99407134b0a7bafd33db4bafc24d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "722009021cdde302c2f46454c694d82f98a5795d2ae62737acf729754b930cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eabbcc84d2f6467dcecf3048b8780537f56bf6e54c1cd96e185d12597ec12572"
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