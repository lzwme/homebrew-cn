class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://ghfast.top/https://github.com/grafana/k6/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "b430df93ba31f8524248d34f00e74e02699023534debb488f4750923ef1ee8f8"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed599283f6a652dc2bd3667c744083520d2c03eb28280b95702e024e40b7ea7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5eee9766f56dfc9e24e091be3e9aeb0d1b251fe03b44f95d030a412b1995bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34dcee570b6b29b32609b2d7c6971c9f7133a3863980d80fcc85ab353cd57620"
    sha256 cellar: :any_skip_relocation, sonoma:        "2668d642362b86f042a8a4d4821eb5ee3f95bd467ed7608a568c5e37adb62382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7092423cfa0f32ac32efc45f77b83e5217f5024da731934d12bb015b196fa5a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b5b524fab140e077d9f19208c8a4e33210420a9b2d236945209efcd3f2267d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end