class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240108.tar.gz"
  sha256 "3772578820616e999916f4c51dbd2415b06f7281f68ccccc5e1d38ed238e3107"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "657f2bc6d84ee02ad3e000dbc1be31afb419ece7878bea79a62bc51cd1faf84d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e32079ece69df4ba720aa4eb2293a9ad32577ccd727c00d96f61a340ff711606"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ba9791d10730b051bbf819bdd78cce998546477cdbc932886af34ab3901f23"
    sha256                               sonoma:         "7c997be41308e0568885b1059c1c74d4f153573fc4948aa221b88ac8cd15042e"
    sha256                               ventura:        "6d7a1b1cc59b76963fbda2bb07874e3d24d8e0c01332c6c7b107ffde8cc80b07"
    sha256                               monterey:       "b609e03ed99436e96ad0b5e13830bc54b51a227316f7e1e52e593ff7c52a7ea6"
    sha256                               x86_64_linux:   "56b373db5a31e08cb2270bac7a894ea112bf6d54f07ae800231d1f2c6235822d"
  end

  uses_from_macos "bc" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end