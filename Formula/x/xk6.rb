class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/releases/download/v1.4.9/xk6_1.4.9_source.tar.gz"
  sha256 "a673d505adf4050df78ddf6513293f4b73a93d72f9e4194ae05b634592326f52"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feb89cfe2ec749ffa7578a2eb7600f2f0225ba184a7eeb0bc6b6c29241304acf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feb89cfe2ec749ffa7578a2eb7600f2f0225ba184a7eeb0bc6b6c29241304acf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feb89cfe2ec749ffa7578a2eb7600f2f0225ba184a7eeb0bc6b6c29241304acf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4a16df04252af72fee58c187131fba732dc3b24e8260cb0a2ab5896f13d59fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12f850f5a84f28508be2966ffc0f6e305a3f7c2786bbeec20c58344802fa8a1a"
    sha256 cellar: :any,                 x86_64_linux:  "eefcfd5567d54a88fe6678f2c4f1827fe027178d31eb7c39dedd3ab4e1e9cfe3"
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