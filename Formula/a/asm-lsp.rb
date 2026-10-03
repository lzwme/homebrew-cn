class AsmLsp < Formula
  desc "Language server for NASM/GAS/GO Assembly"
  homepage "https://github.com/bergercookie/asm-lsp"
  url "https://ghfast.top/https://github.com/bergercookie/asm-lsp/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "9500dd7234966ae9fa57d8759edf1d165acd06c4924d7dbeddb7d52eb0ce59d6"
  license "BSD-2-Clause"
  head "https://github.com/bergercookie/asm-lsp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "841ae55df666f63a6f4ce786a3b71662fbf8b210106660e3c45168bca170ccbe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "722840f4af9b43c029e2ab914dd73f67f886f00391aa6eacb67f1df04f601b32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f63aa59b47fd257e14d99b8f3fc12d0d91a81fe46a43e3ee234720d961d3830d"
    sha256 cellar: :any,                 arm64_linux:       "b2b03ad5c7245ecbd0ee4091decc8ef08f0c39c51f1108c8c44f54599caccaea"
    sha256 cellar: :any,                 x86_64_linux:      "8cb43f74b4528cb5b8c320754cb9099be7e1762c1a324406ac84e387ef6de444"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "asm-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asm-lsp version")

    expected = if OS.mac?
      "Global config directories"
    else
      "Global config directory"
    end
    assert_match expected, shell_output("#{bin}/asm-lsp info")

    output = shell_output("#{bin}/asm-lsp gen-config 2>&1", 101)
    assert_match "not a terminal", output
  end
end