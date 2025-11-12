class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.63.1.tar.gz"
  sha256 "93b8fbe1c86a0d811b803f004f25b4bef22c3ec03b15155a461c4e8b1848cce8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e29875d7bd4f889b81b094c9d57d8df75c79d215b17121362d94146c72fdce88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21ce563cf4a75194a9f4bcd3d2ba90694250dea97b6716355367a5bdfd7f617c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94b8e55a4d7f91187588076427df2c589a8349dc15ec0ac9f0afb13b1c439c35"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2309c13f305daac81c11203819f5fdd41583c232e6312dbe66552b1b4a86d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10cceba702f1813a10548b8e7d38cfba72cbc73e530ad7ef79633395c1e368ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "533f6b507737c28e02c1dd20fc3e60f53105c394404cb0f08b485cbd05234976"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end