class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https:github.comlycheeverselychee"
  url "https:github.comlycheeverselycheearchiverefstagsv0.14.1.tar.gz"
  sha256 "5eb57ae6f6ef2ee41a1cfd9d41d7d3e7702b117b1cc1da832bc627fb80f44200"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comlycheeverselychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a36e5e3126d680285cb9ce78262dab15a39bda6afa39a9062cbff8b54ac3709e"
    sha256 cellar: :any,                 arm64_ventura:  "48a59c2c14bb08d5fd54fe31cab8cbd7ff08665591e95d243fd4bef886cecef5"
    sha256 cellar: :any,                 arm64_monterey: "94e7eb3cbeb39f1b72a9c941b74060fb1c40af9a950cb9c0d81078c9bc6fb199"
    sha256 cellar: :any,                 sonoma:         "231f6e814e702b113ffe3f2b75b2c0f6ff60e54326a6d9b6ce5989b1afcb59d3"
    sha256 cellar: :any,                 ventura:        "97c112de5162883edaffc281085fefd22de6f3c95bf3d499db8e8a28ea81866f"
    sha256 cellar: :any,                 monterey:       "adce99374ac9c8887cedfdec90b6a0edae0fe69a2ec26636453f757960337f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77112f74a8aab60a308fdaf5fd47b8361a8ce1acea75186c849c69b1013ea8d1"
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