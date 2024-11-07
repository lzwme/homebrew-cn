class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.27.2.tar.gz"
  sha256 "f1124aa0a999056e25bdab1e817b4d78d6b3e8928c8edf40c8a0c28242a9c8ad"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ff1c7261530263bb7eef13549d39a1ccd9e612476afcd18aa5c9ef14e3e2dd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5346f6da4c675cdfd2a6708e7f112f44c5dfefe7690b262e5635d434a6e9e419"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21e6cd3605c552e56261b5f720af397c313f09a63788797204d1927ecbe69b78"
    sha256 cellar: :any_skip_relocation, sonoma:        "82c1e5ca6a44688f3805c0a36a30b7404c4342dd2f2bd7fee04f6d0ffe9b92dd"
    sha256 cellar: :any_skip_relocation, ventura:       "7fe77df4959cc810fa07f22d6663f2a267f7345fb027e190f4b2ccfe5d57f3a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dbbbbde3bfa19612f51015c2dd160011f3ee633e5edfdfc9900111333f689c1"
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