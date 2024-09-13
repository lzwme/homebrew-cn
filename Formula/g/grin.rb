class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https:grin.mw"
  url "https:github.commimblewimblegrinarchiverefstagsv5.3.2.tar.gz"
  sha256 "569b30fc1eb9ea895cb4f766cf32a759923f09cc4a9dc5eedb61f475ae25f091"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba76f2976d6dd649245dadb6477230a9c01d565d46c2a48f304559cad3cb1bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f2c8a77f0c2c8b8c9cbf4fa7e617f230f34cf06a2df659ee0e1f13597a83c27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ea126bb7d7b84b7db43491fac85bf840b1214c19dcb23b951de30781b1a13aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e1aeda72c0526805421acfdd6e567152f5e86a41b1496df37b043e56ecd7a61"
    sha256 cellar: :any_skip_relocation, ventura:        "627e2c314c3890c88effaf1318cf9503fcc8f8a7ac031dfa95af6744b738ffe5"
    sha256 cellar: :any_skip_relocation, monterey:       "6710b6fda61ab0fd1da1451b270d61e85abe11222ee99a9396096f20f9f7d7c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef6e2c5c6aa8fd0dfb2f68d0256fc7b128c20a5a894b58302218713cc4d9b666"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  # rust 1.80 build patch, upstream pr ref, https:github.commimblewimblegrinpull3795
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches1a9fc06a277d1315568d708f7379d7c96915f505grinrust-1.80.patch"
    sha256 "5269766f6db0a8827c04790d871074c317a2b9f22b842c3f69c0bc5f7a3bcf9e"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"grin", "server", "config"
    assert_predicate testpath"grin-server.toml", :exist?
  end
end