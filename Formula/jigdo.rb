class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "https://www.einval.com/~steve/software/jigdo/"
  url "https://www.einval.com/~steve/software/jigdo/download/jigdo-0.8.2.tar.xz"
  sha256 "36f286d93fa6b6bf7885f4899c997894d21da3a62176592ac162d9c6a8644f9e"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  head "https://git.einval.com/git/jigdo.git", branch: "upstream"

  livecheck do
    url "https://www.einval.com/~steve/software/jigdo/download/"
    regex(/href=.*?jigdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f650c19b6f867d73389a9c4454bd323cadc57d683962bae896aa6c8e37d56068"
    sha256 arm64_monterey: "423d86a7a9b3825164c2d82cd04c21bb1014745c821cc0b27cdff29eca1d6c90"
    sha256 arm64_big_sur:  "5dcea0cd87545e2112f787892e70ca69a2202044271ffe89f580a21b58ba5f0f"
    sha256 ventura:        "5a247d726d179602b3249137efa25d13c025d3a9bc2bbb24d923b57f022cc6f4"
    sha256 monterey:       "037de4d08cf85ffb4dd2a698a01f16ea31e1eada585544d8f803e6f266a757ae"
    sha256 big_sur:        "be8f640734494f2a4daf4bac0407b80ddf8b56e8136456732d4c5693355b2ccf"
    sha256 x86_64_linux:   "244d944cf955deef5bfb200e61e3fae6cfc49038883f2c542e534b0c498dc4c6"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gettext" => :build # for msgfmt
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "./configure", *std_configure_args, "--mandir=#{man}"

    # disable documentation building
    (buildpath/"doc/Makefile").atomic_write "all:\n\techo hello"

    # disable documentation installing
    inreplace "Makefile", "$(INSTALL) \"$$x\" $(DESTDIR)$(mandir)/man1", "echo \"$$x\""

    system "make"
    system "make", "install"
  end

  test do
    system bin/"jigdo-file", "make-template", "--image=#{test_fixtures("test.png")}",
                                              "--template=#{testpath}/template.tmp",
                                              "--jigdo=#{testpath}/test.jigdo"

    assert_path_exists testpath/"test.jigdo"
    assert_path_exists testpath/"template.tmp"
    system bin/"jigdo-file", "make-image", "--image=#{testpath/"test.png"}",
                                           "--template=#{testpath}/template.tmp",
                                           "--jigdo=#{testpath}/test.jigdo"
    system bin/"jigdo-file", "verify", "--image=#{testpath/"test.png"}",
                                       "--template=#{testpath}/template.tmp"
  end
end