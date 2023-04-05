class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.14.5.tar.gz"
  sha256 "bb205ab04dd599ec95537121a0c92bb04226440e5bbe4fc9245017f4c5da24a4"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b5a17325ab387a304f346cf7fa5b7b7977461d5079519cd0cf5ffb9c40e1e63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e897ab5bb68adf08aed38f1d1f48febb5c96a0154d152db56dbf5939e53018b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "532a38234daeef4817f6dbf3b92ef2ebb33e883bd16a2c6cf21ee24791952f00"
    sha256 cellar: :any_skip_relocation, ventura:        "2b75cd8f33834bbdcae29b18d8df50bd8f5ba08f7e78daba3a327c53070c587d"
    sha256 cellar: :any_skip_relocation, monterey:       "63fadde72e3fe80d81debeb903f8dc2a14ba8410466abfd82f5beb5dcf66eac7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ccda776af6b08da9e3ac9079a8c8f7ccab81b4931f2342a5a44d6a2265ef0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69a32cea7f03fd1d40588d3d4e67cc8098dc479fc955eaea36ac00193eac44ad"
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