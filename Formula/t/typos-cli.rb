class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.45.2.tar.gz"
  sha256 "38e111a6c358b92977eb6592f4f7dc3b01920341c8c852f5eb2f2003126b3b7a"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29ceb622a531fd006fc05eee209f893437d386d4d795623978546965badcb84b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12a1564e65286e683d8b48e8a7c1ef37d4cce91df47b3d975e55ee546af1c522"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f964b4abc8139db477742dc4c16ba41ab84233debc277909f997199db4f15c8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "89e88c0d883b033f79a2fb019096b02693ff9c52e23c444a6e0a1508f443466c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5a25cda16d1a94d28b89c9238f6ebcbce894133d8a26426cce4dcb790e5e70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b827498a880c718a5084bf4161d65140003f01c37fd3cedff1884530bef18e1"
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