class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/xk6/releases/download/v1.4.14/xk6_1.4.14_source.tar.gz"
  sha256 "851543cd0750e3c1dbad60959b56163f9b7f188c7a160d01796eb0c0f116460f"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19abb37008e96d614a74bb5e11283f25d5c20dc99a717210cdb54a60dac2bb7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19abb37008e96d614a74bb5e11283f25d5c20dc99a717210cdb54a60dac2bb7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19abb37008e96d614a74bb5e11283f25d5c20dc99a717210cdb54a60dac2bb7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9be10a33d3283ef82bc12f850866bbdc70da91d30269af704989ad4f3a87971f"
    sha256 cellar: :any,                 x86_64_linux:      "61bdb676802b84d35e76a7575069530b0ee1aa3806fcd9deca390622b6b9f07f"
  end

  depends_on "go"
  depends_on "gosec"
  depends_on "govulncheck"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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