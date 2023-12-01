class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://ghproxy.com/https://github.com/rust-lang/mdBook/archive/refs/tags/v0.4.36.tar.gz"
  sha256 "dd47214172ecf95e1b2cbcbebb8428d0b029e0de5dce74204b3c3a91f26223a1"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00c87e99119f54d2bc401fc473e2ed17ae65bab6ce005960d972214e247796b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad59336b0cdb94bdd5073434b82a5f88554d8e760fc0fd1a2b8182f1632e576a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "389ed0bde872789fe597278cc4987c773802ae2c9859c35da11fb2a5ba41b9bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "34a450ebc7f114b9e28f63e231408f7d7b98f3ac65f56faf62f32ed85a5173dc"
    sha256 cellar: :any_skip_relocation, ventura:        "93b304c632d611c36d1b1cad97b8c44c03d180759b0986709a8bdb244aff6e93"
    sha256 cellar: :any_skip_relocation, monterey:       "3806f8aed567b354818c3ab6e236ac34762aa5f9737904257333aa8873b63a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2099133ad2ad72e281860a79330762ff9e36c22f948e7df9892495df2f103fc"
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