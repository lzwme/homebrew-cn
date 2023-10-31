class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://ghproxy.com/https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.tar.gz"
  sha256 "6a5a55883399cbfef317d8bbf553e57e54945188666b344d9efa98ba3edb57ad"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e4d71bcf5053cf0ba2ce9995bbafc4153479fe70c7f21549abbc7f0155c3f782"
    sha256               arm64_ventura:  "f9ea66a6aad08b33b6ed9076bf39d752063396c2af45c60749aa69866d7f7a35"
    sha256               arm64_monterey: "beeef8b0986b07c3e379ac7b7143d2355185b65e4b01862eb309df4ed25b5fa3"
    sha256 cellar: :any, sonoma:         "db8db6b7fbc12d4179c33046aa880c79366132e5a0a9b4ca44041b9285122fa7"
    sha256               ventura:        "68a88e01f27a4ba70ed314d17b9bf396a7d51d54b1c218d043c8d9f365d2709f"
    sha256               monterey:       "a25df16f46c406df9507cfa2f54ef42f0d8ba2f432b0340c5487e388fb503956"
    sha256               x86_64_linux:   "e21da8a185c06c012b98719182c2ae50285664e540287cb8542203d30e93d24f"
  end

  depends_on "ace"
  depends_on "libx11"
  depends_on "libxext"

  def install
    cp "Makefile.orig", "Makefile"
    ace = Formula["ace"]
    args = %W[--mandir=#{man} --with-ace=#{ace.opt_include} --with-ace-libs=#{ace.opt_lib}]
    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    # Conflicts with dialog
    mv man3/"Dialog.3", man3/"Dialog_ivtools.3"

    # Delete unneeded symlink to libACE on Linux which conflicts with ace.
    rm lib/"libACE.so" unless OS.mac?
  end

  test do
    system "#{bin}/comterp", "exit(0)"
  end
end