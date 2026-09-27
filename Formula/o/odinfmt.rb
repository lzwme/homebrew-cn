class Odinfmt < Formula
  desc "Formatter for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://ghfast.top/https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-08.tar.gz"
  sha256 "e8d368f35b6833efa7e840753881d01f76607f3c0872c614e536f2b7e939f800"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "494a4a081da44055cdeb29830c7b33c5e32e5534739c1013c8ff8504adb12b7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0aa4cb7225e0427fe6237132dcf155bfb71e086f4e2df786fdb62672ad2d79f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b06a56c00f6e06e546abdd6059c0b6d30f044e29fa96802fa1e8fdcd7ed9ee3"
    sha256 cellar: :any,                 arm64_linux:       "b5746c5aa1060c205f6353384e4f703aa541760dd4cd7726ca27b010ea7aaaa9"
    sha256 cellar: :any,                 x86_64_linux:      "0b80172954824ae95f532410ea7b21030e0a9ee3937ab30b93bf614028461bbf"
  end

  depends_on "odin" => :build

  # Backport build fix for odin 2026-09, which replaced `ast.Inline_Asm_Expr` with `ast.Asm_Template`
  patch do
    url "https://github.com/DanielGavin/ols/commit/5f1b4d773b05d98dc9533521490096cf1a06a6d3.patch?full_index=1"
    sha256 "e76914e29a26bca835d115111c1017ec0e6f7d51edc93a8c0e1f9a1fbd7c6368"
    type :backport
    resolves "https://github.com/DanielGavin/ols/pull/1653"
  end

  def install
    args = %w[
      -out:odinfmt
      -collection:src=src
      -o:speed
      -file
    ]
    # Odin defaults to x86-64-v2, which is newer than Homebrew's oldest supported x86_64 CPU
    args << "-microarch:#{ENV.effective_arch}" if Hardware::CPU.intel?
    system "odin", "build", "tools/odinfmt/main.odin", *args

    bin.install "odinfmt"
  end

  test do
    input = <<~ODIN
        package main

        import "core:fmt"

      main :: proc() {
      fmt.println("Hellope!")
      }
    ODIN

    expected = <<~ODIN
      package main

      import "core:fmt"

      main :: proc() {
      \tfmt.println("Hellope!")
      }
    ODIN

    (testpath/"hello.odin").write(input)
    output = shell_output("#{bin}/odinfmt hello.odin")
    assert_equal expected, output
  end
end