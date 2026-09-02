class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.50.1.tar.gz"
  sha256 "871533d5d4be599db158a2644b80da1b5e67d8793a19cf0d5635541f3ef3225a"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "851e914ca2637b06fd828f7b95da921c5ef91bed34ba1b3be4ad0f61a5759a1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a96a51a5dd64fe4ebeb6d81e0cc7dda5b56ba72ab82ab38e841ea6441f34fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50cd51d265d076157dc267cf02749f0aa62001293b819c702f0348b41742a8f3"
    sha256 cellar: :any,                 arm64_linux:   "a308b7ded25351dcc464fbb0bb88994c9cc4ee8a56f07a915289a0fba67ac0eb"
    sha256 cellar: :any,                 x86_64_linux:  "e350e1bb532cb57a9ddd3dddf70e9f3dd2000f91f54ace11e15acd264970048b"
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