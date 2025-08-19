class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.35.5.tar.gz"
  sha256 "2a901f69ce303fb60e41d23c68382f30f85fb20b3d78075d1318659fa005dcc0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc28ce0de6ed4ad089adb7431a9ec9f8a0210d570d4f1d9a792ad196666de6a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ba2d957a6a52931a7309d9d7bae36b050e0f82cca602ae93b2af0cb422323db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3e2b316b2762bcce27a7741c6e42947c26ac186362dba7a821c72891a0d0fdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "97129a34fcc4d5f0725247992cfbc5bfe2676100f2b25b3fa8e84e57e33bf9e9"
    sha256 cellar: :any_skip_relocation, ventura:       "d4d088f65e2b5f74f5e56eadf706032be50433b959b9c2dbf72b5bd432a8dea0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb601e5ba98990cfca75244dd2b44b83767fbbc42195be96a2777667eef1e06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b41df4f4df29588ec6ec5b5a1d447a2b236c96ca9e8351f313f4751a04aea53d"
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