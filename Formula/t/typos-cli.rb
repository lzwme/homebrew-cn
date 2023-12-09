class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.24.tar.gz"
  sha256 "1112aab844ba9c5aa787d370138feddb318ddcb5cf6a1784232112cb6eaeca07"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "822c37c9fa5b01855e84fc85ec4f03fe8b8962db080ee32c41a547600132218f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab2a1b9958e8900a12c5a86957d4050a00298eb04ecf94eeadfe45be4c3a2080"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06a8d7b1e3cb7635b0bae72fce904392b65a33f284c5e979310edfa8c3eb7b2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d2d70d6a27bc7855ecd5ee5376d6fcb5d4015dd3c5b1a992ea55ce3fa097115"
    sha256 cellar: :any_skip_relocation, ventura:        "e4f2f8f6081426992951f4248413562b2b9deeded6397308766a55ca1609d609"
    sha256 cellar: :any_skip_relocation, monterey:       "590a9a48321c93fa406bba4287907182ed1892a8a46ee5159e582c2f32d726f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "694cfa24676fbb64ea117c25f8c82146a2906c7c770d51783baadd40c3b588d7"
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