class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https:github.comlycheeverselychee"
  url "https:github.comlycheeverselycheearchiverefstagsv0.14.0.tar.gz"
  sha256 "52f852beddba06556ac0b83172f472882bd0c66a172de1559773e2aeb112ef0a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comlycheeverselychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "051e1d3606b2329d8e98597e789e0e7744638fb0357b8e1054a05cd52be86721"
    sha256 cellar: :any,                 arm64_ventura:  "eb9c2f3af4bbe200e317752420a28471169b67fccb7ec1b1226e82ad97bc8d40"
    sha256 cellar: :any,                 arm64_monterey: "f235b1644a905e5233d6b2d1a43bab2a87ba0d0f6402883c2da5619f080a0a76"
    sha256 cellar: :any,                 sonoma:         "91d4bfbae6aed7b47d88413d24320068ab92c4349599910b901cd0652633a6f4"
    sha256 cellar: :any,                 ventura:        "7856d9570f8a77d78db4a333dbd66792912851e69b7d25dbd83f08fda0475440"
    sha256 cellar: :any,                 monterey:       "a3827473e68c26166cb49f55ea7dfab0a64af4f6a5209304e357d662949d2591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eb16044bcf0d604b69f4e8e42fb21b936ec77cc3fdbae35fb715a1a80145c45"
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