class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "b909cb9726b77508edc4f81b756a3bb040ba119000358c058670c662f649b3a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3af203bc4ec486dc8ed85e9eb53cd9732c9386795ae88e20538304938855d4c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "810625557e5b7469e911c3896b0c7bede1032fa0e699b154f4ece5fca467c5b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32148fdf3ebbfe49cd2b4511c16ccabcb908df61d7f5f2a93c1ff91205b10449"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c0a36fa049507324675ae648c52326507255216c6fc6c534367d3d19963c5cc"
    sha256 cellar: :any,                 arm64_linux:   "79dac92c4ef017569c460067cdedf3edd98d60049ccb5da437e856eea58d49a6"
    sha256 cellar: :any,                 x86_64_linux:  "bfe3efc012fcb90557a5ecc040248f9a4bf1f872d29d82ad23dc16379708bd10"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end