class Aview < Formula
  desc "ASCII-art image browser and animation viewer"
  homepage "https://aa-project.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/aa-project/aview/1.3.0rc1/aview-1.3.0rc1.tar.gz"
  sha256 "42d61c4194e8b9b69a881fdde698c83cb27d7eda59e08b300e73aaa34474ec99"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/aview[._-]v?(\d+(?:\.\d+)+(?:[a-z]+\d*)?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e0d6d2b0ec534cc1f23d9a43cca5d6e56afae2da62b68eb2f0675907456e0ad6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0209d8c38cb00d749453ae8525b7f54f730930f497026b01d4192c1a732deea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bab18a87647013db5d6556072629a8e138e664a7c7b8f2154179b5eaa6379f7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91d8305546f435e4702c333f28d0ce8590c8b14d8b37707ff2ce398d0b618ff5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4616c937f328391a9ad212bbdd51818d97c629eeaa649ddcdf97e0332e7964bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "9aadc4e50975200d3ed6fe3a2172a516aefece83c83c80ea56bb107b5f8f5891"
    sha256 cellar: :any_skip_relocation, ventura:        "093f941166a79fd776fafdf09576b47208a1a18ce02aa26f404e2b16fe74ed69"
    sha256 cellar: :any_skip_relocation, monterey:       "2d671edc613c82993fae031b0a2795aae4a88a19ca4051095ae174aed038b100"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a32c517ba508c6febe9605d4c9f4d8bde9200393cd8e4dd51adeb7c6e85fb6f"
    sha256 cellar: :any_skip_relocation, catalina:       "ad92a0e964ccbebe685edf9c595efd420475490d255caed072985cb128a8230b"
    sha256 cellar: :any_skip_relocation, mojave:         "fe70cf7dbd1d2e1473da3818b96d3a94d811e93d52ecbb6ecfc1c1e1ccb8b12a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "4f5fa09318475fca46c584b52e5d5b845cd4d331df04744ca41d6789575b32ec"
    sha256 cellar: :any_skip_relocation, sierra:         "95cbb14a2a5cb4d8d11d9ca3621e81705df77f47d85f89383913e3a02da56041"
    sha256 cellar: :any_skip_relocation, el_capitan:     "cb20b8513b3b7d2977943d7ba14f2627892697e9a6b69c4366563786810ca95c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3223307ac974a5f3c1c4720b8ae6f1a5f8560eb8e8fd03882c2ffba1fb5a76ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2a611a1c3b2b1c76816dffcef6b3aff9f4ea88f6fbd87729dc987c39bd7cc2a"
  end

  depends_on "aalib"

  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/aview/1.3.0rc1.patch"
    sha256 "72a979eff325056f709cee49f5836a425635bd72078515a5949a812aa68741aa"
  end

  def install
    # Fix compile with newer Clang
    if DevelopmentTools.clang_build_version >= 1403
      ENV.append_to_cflags "-Wno-implicit-function-declaration -Wno-implicit-int"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"aview", "--version"
  end
end