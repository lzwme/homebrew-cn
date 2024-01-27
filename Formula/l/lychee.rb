class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https:github.comlycheeverselychee"
  url "https:github.comlycheeverselycheearchiverefstagsv0.14.2.tar.gz"
  sha256 "f2c23c564647960b6852f9814116e7c434402bbda71ba650a5624e0bc99f6bbc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comlycheeverselychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94bbba8ae1e7b37cd919e4683f428e299be150f247b1fd209c4ee049c027dc1f"
    sha256 cellar: :any,                 arm64_ventura:  "f1b9788b81d40a76a3b82bc2ebb35ca5449b2f9cd47a1564d7ea9acf528b2fde"
    sha256 cellar: :any,                 arm64_monterey: "f795e0f89208c4abbfd50422f532cb01b04e2821a91aded18448b2b70ac6a4ae"
    sha256 cellar: :any,                 sonoma:         "a0d4fbb87a94e4f2662891a7850d96a84e972dc3b4f2af7eb2674051d8e99d81"
    sha256 cellar: :any,                 ventura:        "a92fdd33720b7338abf0be0ef50f4aa8d5cc9afe83f7d133d96a6769110062c0"
    sha256 cellar: :any,                 monterey:       "ef10c621506d345f27e6abe2193a19e99f76be3fcbbe917f2ea5066af82b4766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e32faa4dd6b0bab3b8fcccf7c8b25e93957074e493f3148208c253a637d7ce0"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath"test.md").write "[This](https:example.com) is an example.\n"
    output = shell_output(bin"lychee #{testpath}test.md")
    assert_match "✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end