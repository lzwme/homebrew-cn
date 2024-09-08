class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https:github.comemilprivergeni"
  url "https:github.comemilprivergeniarchiverefstagsv1.1.2.tar.gz"
  sha256 "b1ab7f06273b0d14fd5f8b41dd8baf66a1e8b979220be1ad1d27c162cdb16ee8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "820704ef0efbaa0dea4d43c037365cc0f6962fbf2207797265be502665b4e03c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c20d99210faa7dbb5d3c209a6e7033fd3d98c8ff9d548a2525969e452b22dd76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51620d1bde2bf1cc9d7cc5058526162b7e91e7bc70e256f10e2acf9226a9ef3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "02c7fd0e5d2dcdfb0ecd32c8bb1f49a831409489c026097591b162acd9591fa9"
    sha256 cellar: :any_skip_relocation, ventura:        "5cfe483e86bdc7297668582ac8859922ee2a1e42f92bf42c806e443b75ea578a"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef4f1ab5ecbf393bbac3c48f81f4dac5d30bcfce21e4d2824d2fdb04061535b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f4a2b579700bb7880a656741b58dd8d4c219fa1c0e475454a72580bf4822ac4"
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