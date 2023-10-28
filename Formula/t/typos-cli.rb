class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.21.tar.gz"
  sha256 "3cb31aef6660c1ff58b0f8a37b437894fd505f65ed13562d1d956351e7ea6ed3"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a1531ad1ef118fd02b566892ec0ee9e33267dbf78757c8bfbfd2c7f4db64094"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc979c4cd60761c6b6b7b2066b018404dc3380148fff0475fa56f63b222ee89e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b2157fa77451c88bf4f459ba2857cc7a5440624ef8445fa0aa0c092b04655f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3afe6240c96ea570a421e899890cb5b745c0e019b523ab6b32545fc49f0d4376"
    sha256 cellar: :any_skip_relocation, ventura:        "5c92bf8b9b0a7753f52916061f8610f88ec8d17eb794951e92802b92ae922756"
    sha256 cellar: :any_skip_relocation, monterey:       "753a449e6a4950d22dde007755d590e1a015db8d10ab2b4ea9a0976919b44ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab80d0b0b8957921423f7d3c282abb17b18de549cc0ce1e116e1a4ef8433d2bc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end