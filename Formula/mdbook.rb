class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://ghproxy.com/https://github.com/rust-lang/mdBook/archive/v0.4.31.tar.gz"
  sha256 "0eab74f3861db63fce1a6624cc84a834441f35558128fb0b2e12f8806311283d"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd0a09b7495a23051a3d7f3b98b4a2b5c31f7ba38f9409bbbebd1c090712aa61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e694cab5aed758dbf37ea641e25c9dc873028c7ba0a49766e865b8a1295b933"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a232a25595d6aab709b5dcfe499e02dd3cba1d6f0b6cb76fb3c8dc1a8e63af0d"
    sha256 cellar: :any_skip_relocation, ventura:        "1f28d7279935cddef953732a68c66f8d191415547dbc63bf8e96c5a334d9050a"
    sha256 cellar: :any_skip_relocation, monterey:       "712795111fc361a1e1e6867e91a6a331122fb8daade32af52185d9e9dc92c032"
    sha256 cellar: :any_skip_relocation, big_sur:        "56d4a40532b72a5719800f1e4f2b71c451c103be7e44dd3396ab38a7d62a8435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "024dcb1fa5187e6531dc3d114dc1cc014c0b5cb27239f99a5cfdd28187f04fcd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end