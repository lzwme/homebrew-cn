class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https:github.comhouseabsoluteubi"
  url "https:github.comhouseabsoluteubiarchiverefstagsv0.5.2.tar.gz"
  sha256 "a4a92d120e6d8ccb8fcf6722b6a6ac87357ff87b2d50296d428216b62a038377"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comhouseabsoluteubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b7ec47fb63209d5871eb9836e1a2f19e1dbf54d092715fc3a000930d04d69b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d43ef587509f1a31df3e8827340cf75e2d7622b99124cb0307d14fe349d13137"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c601f5856f6241abb52a6125c4a95432766f07c9b10fa0ac8b77a7913ff4fdfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa8af992b3ce1f958d0595db60407484b13f5d47b9c87e8ac6125617620112a0"
    sha256 cellar: :any_skip_relocation, ventura:       "e67f2960e5f9c639dbde3717eac7300579adf288e978dbd1f9f2b56dba7ce48e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08f8efcbf5bf3e5bc2afdd29e8d592f83153e18f1642920bbc220e150052b21a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ubi --version")

    system bin"ubi", "--project", "houseabsoluteprecious"
    system testpath"binprecious", "--version"
  end
end