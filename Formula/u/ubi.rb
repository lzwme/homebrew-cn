class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://ghfast.top/https://github.com/houseabsolute/ubi/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "31e4b4e60dabc6320782a4c942428eb9ad7711e114121c25b065375c4a2e335c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c50764e1b68280dfebb0663931caac4528075f7fea1a16da1ebc45a9c73c3375"
    sha256 cellar: :any,                 arm64_sequoia: "8155520f31ec693d3ae3b16bb50c0dc5670e3c453f0f805caef0324a453b483a"
    sha256 cellar: :any,                 arm64_sonoma:  "9cc16d2cf3ae35c9b7e735ef6d9331b23e9ebc4535f85d604142d453cc458821"
    sha256 cellar: :any,                 sonoma:        "c5f67f7e5a21f3a385a4ab20d7aee978d0b03f53550b867e3805e6d9de6ed06a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57e72cdca42bb4dbd0d402316a8327ad6e28a2b9e084cbde38df2697deadb0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fd10cb0a5d14cf1e71df8763c2720eacccff4aa04133febee16a15bbbf0393a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ubi --version")

    system bin/"ubi", "--project", "houseabsolute/precious"
    system testpath/"bin/precious", "--version"
  end
end