class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https:github.comhouseabsoluteubi"
  url "https:github.comhouseabsoluteubiarchiverefstagsv0.7.0.tar.gz"
  sha256 "7dc99fe385447a9f48972306119beb84c9f00704265cc96a1be55293a041c1d2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comhouseabsoluteubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "850d2ed925f7ffae791a0fb0d1314d27ae598ca9c0724f9c4b4b71ea4af5ced7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "871f99a1aa04b3552465375fca57e5c1168c2945c0c9b37362f6671c94def696"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95c4c8267e38f9c1602ec087508752d24e02f450a911ed458c1fbbbae5a7ecbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "158b9d4d4f62c7caf0d9f02234e8b056ed07b439a5d5f919639c442c456148dd"
    sha256 cellar: :any_skip_relocation, ventura:       "1fbc790067e17881d67b63a425e08c34fee95a74677c7b42f7d0b6a84c09e67e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa2f2d88ad0b054ad93e6890d6716eaf0847eb1747adcd173bd8808b1f8e0eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16e5d423c78bbe999c218a0e02e355502a6b12b5a0fe08c7882f5d7de936b609"
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