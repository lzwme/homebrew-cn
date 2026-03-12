class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://ghfast.top/https://github.com/rgst-io/stencil/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "4338417e2a7bae8bdfadb37a01d29b5ed565ede785ba2fc2074c1defba6d9000"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bbe850dd8ed609e5a5ebbc94b24eb96b9d695038e25b47aee45d0904b0f026f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeb1e4113974a206106283e1cfd4a43420426d1af8b883f4fde945cd097e4a0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0569f81b0a39ff28a99c2e8ee2920a101d2df315741faa8dbaf547819f637ca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "50fff448e20ccccef7890bddcac5a1f1decd75b1f329df6a2617f12d6dd069f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cad637d9dc5d3685ecac52ac699a272f08e19f6285e222d715f540f8fa1398c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b42287fa20945a3581d0c12857113f2e605c808020d51b5685ee5b581b2255a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end