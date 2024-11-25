class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https:lychee.cli.rs"
  url "https:github.comlycheeverselycheearchiverefstagslychee-v0.17.0.tar.gz"
  sha256 "78b006105363ce0e989401124fd8bcb0b60d697db2cb29c71f2cdd7f5179c91c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comlycheeverselychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd08ad63d8bf01cad1bf845bda209397218872d7f452873422e8eb031927276f"
    sha256 cellar: :any,                 arm64_sonoma:  "e29b8c7cefb1bd156456181e715ee8e330b2fae0e62908c0e3fd8a4a74637ca5"
    sha256 cellar: :any,                 arm64_ventura: "4be250f24fc411d3ebb8fd19464cc6e9efd863b38b2891614f58b1ca73e6c8f8"
    sha256 cellar: :any,                 sonoma:        "ad87802e428804db30d5fefb56653256b2df60e20004f53eec60b283a838c290"
    sha256 cellar: :any,                 ventura:       "c9dab3e8116a866e63a32389841e2095ae8dd0dcb9511c49eb8057eda026db71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a77915e38f5ecadbd1c52dc78f03233b0e4fbe0c0b9c665a989f5b8be79a939e"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath"test.md").write "[This](https:example.com) is an example.\n"
    output = shell_output(bin"lychee #{testpath}test.md")
    assert_match "🔍 1 Total (in 0s) ✅ 0 OK 🚫 0 Errors 👻 1 Excluded", output
  end
end