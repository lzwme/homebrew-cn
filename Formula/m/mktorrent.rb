class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "https:github.compobrnmktorrentwiki"
  url "https:github.compobrnmktorrentarchiverefstagsv1.1.tar.gz"
  sha256 "d0f47500192605d01b5a2569c605e51ed319f557d24cfcbcb23a26d51d6138c9"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a6c0b4358e1b70f05757b6e016d039c645cfbc6e92cece0b69b1fc12dc5e97b"
    sha256 cellar: :any,                 arm64_ventura:  "5ecd805a7cab873d9a32dbecca561cb49cdc1e200dc1eb5e009e0e02a7202b78"
    sha256 cellar: :any,                 arm64_monterey: "bea6dc20b4e3276571b8dd0e42ab6d3bf6351d8746da085e65b4c3685f1d0fee"
    sha256 cellar: :any,                 arm64_big_sur:  "09d65c9299c56ddc90c69192019452719a7492f7b3ac9cd14af32554d8c2ba35"
    sha256 cellar: :any,                 sonoma:         "b964d918040da1a86e2fa3b4557dd14ecca65eac0845d289c2722464b2eb12a3"
    sha256 cellar: :any,                 ventura:        "4fd92b8b522faa30fc1433bb6dca8550e81c7936344c09cd490a714b11654cc7"
    sha256 cellar: :any,                 monterey:       "b582261a10aebf9b44820f6e30a38bf8941833a9ffc3eba2a5869853c5514ef8"
    sha256 cellar: :any,                 big_sur:        "64810768318138d7d88d4915a619644fec95fb789d028508bde97b82e0e31ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d977a90d91e84d0064b6d2134a85454c500d2093afece3e1b1e6d393c091cac"
  end

  depends_on "openssl@3"

  def install
    system "make", "USE_PTHREADS=1", "USE_OPENSSL=1", "USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end

  test do
    (testpath"test.txt").write <<~EOS
      Injustice anywhere is a threat to justice everywhere.
    EOS

    system bin"mktorrent", "-d", "-c", "Martin Luther King Jr", "test.txt"
    assert_predicate testpath"test.txt.torrent", :exist?, "Torrent was not created"

    file = File.read(testpath"test.txt.torrent")
    output = file.force_encoding("ASCII-8BIT") if file.respond_to?(:force_encoding)
    assert_match "Martin Luther King Jr", output
  end
end