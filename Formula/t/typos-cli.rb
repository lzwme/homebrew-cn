class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.31.0.tar.gz"
  sha256 "45a9e1e1e1255d86bb57ad62336d5d8a919fb90f2f5fc71845a3be94566f5e12"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100306835957ad6a6f433ab5544e3cfad6df56245bf3b3c408e334d90e721c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bec763b0e7a7fa60f6367416cc7c33c5f27567d9c6a35ee83bb9313d215d6831"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a535698ecda4f2382693cd72f794c409c72fce034cbd396caa4c7282e7e695c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5e4a4876cb2e97b7c43e0944b3733160978c15a5d54f4e53cba1f8c819b19c9"
    sha256 cellar: :any_skip_relocation, ventura:       "7de2f25c20b81d32f7af0bd7ce67d6bfeeedaeacc4408047ddb51070fd4787e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce814b1a17ca1c352103822f0f03adc9068a62b63f36748d7878ee8243d7f168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bede7ed71200659f2a1beba7057b65a4f361059e201676c3b62c0c3f7499e30c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end