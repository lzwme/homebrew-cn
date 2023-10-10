class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.18.tar.gz"
  sha256 "b75bc10ce85244ea2d8eadc69bbc8f31bdeb44aa5531d279d9c2be020c58093d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "475948e37e58615685ff7082ea702274d1b3346b72b018a4718880673901c1c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "014028ddf78fa22531cb18ac68143d1b53bbc83f4e5f3fdc532cf60bb695e40a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4ef8888d53d7bce04c52a81488113e04c48a3274af414e300e01083253b338a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3f8318c1142e84f94a11157712abe002244f77e88d0279252cf538db9a3a8ac"
    sha256 cellar: :any_skip_relocation, ventura:        "0543bc058e490cc446b751b81c28e3d2ee9abfebeacdcd06f6d364e317a4ea09"
    sha256 cellar: :any_skip_relocation, monterey:       "3d38911a3c2d451e8c07cc311c10379186baefde4c4056e302aa075fa1f45bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4b9269bbcbd39c2d95a9ea40616480e88cf93ce41862a57235978e7c6a15a7b"
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