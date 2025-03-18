class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https:github.comhouseabsoluteubi"
  url "https:github.comhouseabsoluteubiarchiverefstagsv0.6.0.tar.gz"
  sha256 "77ec5b786066168d25b8ae98c14f144c3b4bf9f0f3ddfc423c9e808c30d69dbb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comhouseabsoluteubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e18242d6a70b1bd72c2a6036f84fa3c07e75ab8330d215738ae81baa8d078c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "498923a422cfcfa64b62d9ee592ffdfd696cbf02a523ffffcdce8363ec7aa617"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f7574296000a1700ffd07a1744489338b2565d4736998c7b6eda02f874e4d1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "44257cb41db407825d261d588f275ba056a84b55384a774fbd55b1b35fd4a40b"
    sha256 cellar: :any_skip_relocation, ventura:       "d4eefb519a19102f04f9e6105a828a9529199994f4ab72bb3d86863ea4d73853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cceff241f5369796b38303d5c2d768d383cefb9ea99f9cbabe5c0c9a65e5b779"
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