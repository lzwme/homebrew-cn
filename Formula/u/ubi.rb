class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://ghfast.top/https://github.com/houseabsolute/ubi/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "804156727699460fc73ebc0b8b807c09ba5486a303dd6693cc5619a9df367e2b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b9de2eb462d7aaa5dc08e1fed86b85c86a7a1996c23ec52ec42a1519bbf5c3e"
    sha256 cellar: :any,                 arm64_sequoia: "e3ff53aa86b100aa2bd0d150a6714a0b4e5f8ffe43ab57f7da57b38c9fb67ca5"
    sha256 cellar: :any,                 arm64_sonoma:  "abd58cd80ecd37db6da35ebe7d90339ff3dc48ab01e1897a785c8d6fd956dc9f"
    sha256 cellar: :any,                 sonoma:        "19081eb6581c383ac4789c79dd5317ffe639afafda16367ca23d59fb04e1770a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ee8c6a956b66bcd1fbe5feb3dc0992244b70ec9912ff7544f3abbae1b8b6c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0cc83d96bcaba2da4d3d57ee20969643b47654c7e1fcbdd5a5d6595688184bb"
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