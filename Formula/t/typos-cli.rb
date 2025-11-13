class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.39.1.tar.gz"
  sha256 "6a07c99422beb92b558a0c8d3457d4a7148317000c25c8e0f813cb614038e5a4"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce8a205470d467f1f36cb71eb8f60a7e20f3cd48100a8479e9bd0129fd2c1800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1a23ebac62a021e65df706fd387d333cb71cb9b6429b671e6415477f6c17971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee4fc46e0414d994ff622ea54690a0a111255cc5b369edcc12fcf4961a732735"
    sha256 cellar: :any_skip_relocation, sonoma:        "567e1cacf05c946648ca24804bb76abc58face56817e4211abe61152f6ac80eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1428b96f5a02739c646814e676565ab6c0542cd52dd75945ccf685a896499888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22be855e9fa08b0481ceef96bff98f96ce9c4d94050b5d8d02d36fcc3e178929"
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