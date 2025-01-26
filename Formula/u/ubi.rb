class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https:github.comhouseabsoluteubi"
  url "https:github.comhouseabsoluteubiarchiverefstagsv0.4.1.tar.gz"
  sha256 "130187d416b9b1c1ebbd40bc8c9cc4860564c199e15140f49d8394f0c468bee6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comhouseabsoluteubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdd4d108a918e05399f76255916c3d802e3c666f0e355ceff6bbf455643dcf2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31540cd3aa954cc6853bcdca1b234cc9812410dd2b5d65198aba992aeb5af1d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a4b09fa88c18b6e0e5ed52d08a4af2cca9b474d1680ed6db415925fa83f4d8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf18f776622d0e46fcf90a01690ae3b61eb52f16a01502ecb98fe2f1742fa737"
    sha256 cellar: :any_skip_relocation, ventura:       "c1134cc47586bd6a399f7b5b8ddc877a2c8b90f847c52b02c2b2e955f30277cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91d8015527da74c8ed074e0ff4f0baeb4292e158673ad575f72560520c3a20d3"
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