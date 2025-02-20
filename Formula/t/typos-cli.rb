class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.29.8.tar.gz"
  sha256 "a3f4e32a61853266b9d73a56563dadd616cd0cb3bea693679927325b8ee31a33"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3219995291aaa2cc768d453d5f2c5ffbe0c22c022e3daedee37503a338b972a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc5e60ab345311a029a387e2f9411948f5bcaff6c7eb242b87fc50c47a5af55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78fc576f2ea277cb9705f3d460ea1aac60dc56e15ddf70f6cca369e5117ea2b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5ce6ef602c8d2a78bae690ee15d5a3d261c491fcf3bb5dc7016d8fd1b22195b"
    sha256 cellar: :any_skip_relocation, ventura:       "2dd303d248a62ef17fb72a461a02d19fb416edb8f957b4c35656a905112b6e35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8b7fa78de03bc3e83cb8b957b7bf53c81fcab21046c569876d68c4bf281d215"
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