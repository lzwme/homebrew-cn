class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "46f343fe709bd0aa3f2404fb5c50b43b8e344b8bab857534fe4d88b87d47580d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b214ad0765632dbc9c032ea2e99cee4004c3a04fc717ee8dec009d48205cfce6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac5aeb5621270b9873009776de2b75bd4761f74d2487e45309ace6509299565a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4989f3ff328e0aca423f0fbd50e1ccb78cdf60abd2b5248b229f60802ebdd43"
    sha256 cellar: :any_skip_relocation, ventura:        "a6278ad09238655c77b4d6365b6ce91484bc5e66a8303aadfbb9efe173a50012"
    sha256 cellar: :any_skip_relocation, monterey:       "be53ab36c3a0c10c5ce39d41ddd41bacec5f86021f9080b0e40b084054df1472"
    sha256 cellar: :any_skip_relocation, big_sur:        "3df0bd08b73f7408357bc11b994e8d5b34aaec131d37a54c108c877feccc3b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9d96426ea569d8511ff281e5bf23f24c1e81d5bb63e1a38c1f193536a797254"
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