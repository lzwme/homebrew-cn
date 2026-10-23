class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://ghfast.top/https://github.com/swc-project/swc/archive/refs/tags/v1.16.20.tar.gz"
  sha256 "26d8ca8a93c2ee15606340cfa794d97bcbb8b26bb668edd8ccdeff8a0202a649"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c05a2018895474a916e3fcaaaeb1337c2ea897052625ef1ea468caed8c40ca1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93de8ed80172cd912af1790531c8a664295269601a23f365100e27d82225f772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cbe2a85202e0fe52ecb464ddc183afd3d2482e895bc79345106fbf6a6e5d8532"
    sha256 cellar: :any,                 arm64_linux:       "f9fa7ed5ea1a62e6c7fb26fa5de2f000e414df7848e95d295bb18563f3bb47f4"
    sha256 cellar: :any,                 x86_64_linux:      "d974bcb898a18ccc9bee89f28a6e3e1d60893334b050bbb081b59a7a33c0ac42"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 134)
    assert_match "Lint command is not yet implemented", output
  end
end