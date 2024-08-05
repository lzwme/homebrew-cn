class BbftpClient < Formula
  desc "Secure file transfer software, optimized for large files"
  homepage "http://software.in2p3.fr/bbftp/"
  url "http://software.in2p3.fr/bbftp/dist/bbftp-client-3.2.1.tar.gz"
  sha256 "4000009804d90926ad3c0e770099874084fb49013e8b0770b82678462304456d"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "http://software.in2p3.fr/bbftp/download.html"
    regex(/href=.*?bbftp-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00799fab3efd0fd9c823854c0113ec44d2c4d13d7c191d79165e0ddc75ec71e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f99da3815fbef62edb3391bdf9dab41055ed1ace3f0b30cd69c45e719be6149"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d429a71fe3b54e34d75efd1480062c322cee2a9b471628a671de3e9f1b91b201"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd7a47c27111d4dc064a7009f919a3283360738329dcfde7eb6522ee280e78fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "86903930a6e0fc3e443e2520b0cbaa595203e1bc4f2475d7cb714dc5e28611b9"
    sha256 cellar: :any_skip_relocation, ventura:        "7808120a9bee27c473f0f59b5223c9d709add5ed8d8609992d51efb4288fb89c"
    sha256 cellar: :any_skip_relocation, monterey:       "e50848489c6ad43604cbc0730d027939830ddc50d46fdd8d18dc6f729a910503"
    sha256 cellar: :any_skip_relocation, big_sur:        "f30650734e1829a0c399153c78088ccd987f28ede25b8eb13ecde6b138d55076"
    sha256 cellar: :any_skip_relocation, catalina:       "6d5bed31d69a0ff2f38f2642176cb3c3a4da34c4ea2740567d2698ca62519b7d"
    sha256 cellar: :any_skip_relocation, mojave:         "bdb7c899dab18816b4cc1d573291ba4691f365c9ed1c9951e73f9225810a8557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be2f6db3c1cc87a51bab6a760cb1143747faeb3819f731192f09fceb3a658fbd"
  end

  uses_from_macos "zlib"

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Fix ntohll errors; reported 14 Jan 2015.
    ENV.append_to_cflags "-DHAVE_NTOHLL" if OS.mac?

    cd "bbftpc" do
      system "./configure", "--without-ssl", *std_configure_args
      system "make", "install"
    end
  end

  test do
    system bin/"bbftp", "-v"
  end
end