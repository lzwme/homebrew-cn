class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.23.5.tar.gz"
  sha256 "a248d0383fe489473b181b1ed04c6056f815bd746b7319ffb6ab63dd84bd900d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d2ceecb24d8211fa5ce0dee5f8191fc2c9b766251de2f1f928f232e40aaf61a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5722f5a7297468998cc177f70b3c0992f5327841780b87839b42d181d2fff87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "861f055178b2e2fbf8b0ae3c4cfb965758401c0d5db680fdd0a0a032915c5eb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d2dd75916dc9fb1a32e857f85c966b84245da3e4063996efdfbce5af8470e6f"
    sha256 cellar: :any_skip_relocation, ventura:        "1dcf2e049a51dd86471beea6550630c5ddb9f21ea95799f9320e4c77a99c0730"
    sha256 cellar: :any_skip_relocation, monterey:       "006d5721346b813b4b39466d70482783e6e41a2f3eebd569a986f69ac41fca27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "749193fd00218e17333825e00d38e75ef14c85ee05d390edabfb06820a59b831"
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