class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.23.tar.gz"
  sha256 "3947439f2cafa345f7a1c953aaca3c39c0674a6ea35da7812e34ffa641482aa7"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fb90088f84f5c08497d2541c8086d18d9f631a0dac23a72a3617f15a8b38bd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1350241b3f5ce2a1646ef3e54b7c9853c32cd39260c6cdfb09b5f6e6e75c5d81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dedcb08db24e0f5c5dda33dd40c4f6b13dc75a031c7fd0d800621c15f228ae6"
    sha256 cellar: :any_skip_relocation, sonoma:         "30a90b4afa7bc445c76056751e2662605e1390a59545b57a0d0ea32a0e009fdf"
    sha256 cellar: :any_skip_relocation, ventura:        "e156b3f77e05ff6ebd2387a6b7017c1c34076831720c18bad31e50976fcd40f9"
    sha256 cellar: :any_skip_relocation, monterey:       "d4504d8aa715b2bf91f2cd864914c5a929f5c995b3ba0eb07bf14c1c27146169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b80dbe518798bdf2d5be2adf94977a41b0e32960e84d3488994af9c7ea3fffd"
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