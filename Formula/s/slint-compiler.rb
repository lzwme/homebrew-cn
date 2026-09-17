class SlintCompiler < Formula
  desc "Compiler for the Slint UI markup language"
  homepage "https://slint.dev/"
  url "https://ghfast.top/https://github.com/slint-ui/slint/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "399ef10a0bcd8db236f755e68548e2e55e7cac00ee3da7f50e8d9d6881d34c25"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "743901481ea9b37a8863fccfec22baddecade629674e44542b6b031b8d71f03c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27f3eb4b5e267073fa19ed7e94c0a0be71932e3edcb03067c12a11d52c7a517e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8cb924528b6f5c3a916d2fe06dc71fae4a734f043b26a260af9fa1885ebb193"
    sha256 cellar: :any,                 arm64_linux:       "b8d54584bba96a0e301f222e927804d31d5d0a4625bc05250553e6adc86797a9"
    sha256 cellar: :any,                 x86_64_linux:      "e6e99f66d7bb8cac9ea691f70c6eec7de2e9d0833bcd7e96e0da74395745cd5f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tools/compiler")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slint-compiler --version")

    (testpath/"test.slint").write <<~SLINT
      export component Test inherits Window {
        Text { text: "Hello, world"; }
      }
    SLINT

    system bin/"slint-compiler", "--format", "rust", "-o", testpath/"test.rs", testpath/"test.slint"
    assert_path_exists testpath/"test.rs"
  end
end