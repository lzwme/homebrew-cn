class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.35.3.tar.gz"
  sha256 "4fe92c20520e358935172f396d8e88050be39512425230a754a6e958dc268d69"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc33fe7ae3eaecc7390cd133e3986672bd60755e7ef975e617f2d70b3f95262e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e7ce62f4e62f2c011b0c1d1627c556dc22d63953a781b16cce2691c39d26ed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7da3e5e573dc7e1c6ada535836f7e1e12b3c2b253e7e22db898c1c001e3feba9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ae417924c982505375e46e9a4d427933cc7a06970050184f7998799b071fe0b"
    sha256 cellar: :any_skip_relocation, ventura:       "d2aedd512ed6298aeee98889c82976b7afab52cbcbcf47fda1b18749a74072af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc8a8d97dbde80f5593417a0e8f66256dd2978b01ac9f0b00f1add5c61b85bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca1f42f4c7727dff29e45075f29dde95d3edbb776ecd70b01d7347e3798e6bd"
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