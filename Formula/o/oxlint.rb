class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.87.0.tar.gz"
  sha256 "d8f4c98c8983ab43fb6ab587f5fa215261ff6936a34a7b45ed9025f893fe5f14"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5791ed457833253e183a95f382a386bd1c61fc840dbf574edb0661cc9ff15b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fe44df5c3d45ad53d3605ced8bc686fd23f66f102e029b3ed8a024d23956be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f966c3dbfc711cafd1eede45776dad1eedcc5b4fcf1acf8d921a25aa2ab7ba3"
    sha256 cellar: :any,                 arm64_linux:       "68d51f0937a828731c0142562a5de156a2eeafa4fa566975903bc2c809b83358"
    sha256 cellar: :any,                 x86_64_linux:      "9432f359ae8900413b943a206bd02a7b8e74ce45582fc5af0b754003ea71655d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end