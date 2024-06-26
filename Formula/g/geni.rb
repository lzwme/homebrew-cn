class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https:github.comemilprivergeni"
  url "https:github.comemilprivergeniarchiverefstagsv1.0.9.tar.gz"
  sha256 "034a268d73ccc0c524aba4f8ff00124efd665db5e17b8b5db7b0a8dc03baabdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "085eff4bd61aca57d3bcdba583711859412a55d671d6a8f4880536dde143cc90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d08bda46922cd977759ac9df9e8970177ba9b0223d9c4166a4c9561279a95e66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b828dedeb48838472ed5a573e39bc2a6c6e7a1c841ab02b59209509b51d5f13"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f7c3dd4d25ef9783927b515d69732e10258846c47cc0a483adeaa6caa7851c1"
    sha256 cellar: :any_skip_relocation, ventura:        "710a67bb522855a436b95a21eac4b0cd9caad8f3f951dae8347aef98a870dddc"
    sha256 cellar: :any_skip_relocation, monterey:       "b7268448e325c2e944ba78082e32027fde9c401747f7e0e60f3a6f3b308502e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c66e3ab08a9ace7ac99474228e3a104283b8876833ec01ba3ed821ac536d84bf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3:test.sqlite"
    system bin"geni", "create"
    assert_predicate testpath"test.sqlite", :exist?, "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}geni --version")
  end
end