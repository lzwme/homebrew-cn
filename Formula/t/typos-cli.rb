class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.35.4.tar.gz"
  sha256 "a1e46dc0992ce0118c53bb3c4dda5c20d10d2e6c7a1df18b7c80ba2460597963"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35327aa1534a0e1016a43b825dba7d77536b30e7675c74a872b8af46c76abb14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bdfaa1956be9afabfd8f90242d368e502d5368ddc4455e6b961171727359c1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f039869a1d2ec2583dc7da2af9488dcc7225981ae4a88f0b84cc08baa3ea58a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac59ba87ccf90defa1f02b1719e67fe0bcaa2bea2bb8fd40dc274d3c12b868d1"
    sha256 cellar: :any_skip_relocation, ventura:       "abce68b236edcf2e935ac673a38229a334cab28a932be6f7ede8aaaa1111f01c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf158d3cb652519c142952cdd98202aceb90d9ab9d2f9c643b3b6a535613b6d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "940a4ab25c8591ae4cf5ada6406ddaae007ced8a81ff32b16a3e9a9837319003"
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