class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https:github.comemilprivergeni"
  url "https:github.comemilprivergeniarchiverefstagsv1.0.11.tar.gz"
  sha256 "510ba96a3a9abbc85dade9780e81aa6b46427261e690a5c0dede3bb5bca25f1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a6c96fc6cec063eb4054e5f02a83a85d0660263f77e0efbec38b47a790af8d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40119c8ad2bea78fdc3af7115771d574e43ecd00abab8645db4238c542ae64f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6bf803ddfe0ee4aad8684bdd1f21f13febec81b36865d1756bbf3631e4f931e"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbd334d7abfece636a04c0782ce9d0cb03925a416e87c3b1b45edccd6a1728e6"
    sha256 cellar: :any_skip_relocation, ventura:        "2a786053685258c4f4480a7d4f59490577f2fb284024cf776bfad97b1e9a1ded"
    sha256 cellar: :any_skip_relocation, monterey:       "6108c018a2812df12289e0bb0b01d84b6177002aaa5f76fbafcad557dc3db779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deeda411449de63fe8c26840bdaa26d8cb9d45960444210cc67884edc977d27a"
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