class TokyoCabinet < Formula
  desc "Lightweight database library"
  homepage "https://dbmx.net/tokyocabinet/"
  url "https://dbmx.net/tokyocabinet/tokyocabinet-1.4.48.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/t/tokyocabinet/tokyocabinet_1.4.48.orig.tar.gz"
  sha256 "a003f47c39a91e22d76bc4fe68b9b3de0f38851b160bbb1ca07a4f6441de1f90"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?tokyocabinet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "4f3639469a608b0ad65b82a7529849eb87808348165e167cb3ff347cfb92dd54"
    sha256 arm64_sonoma:   "2b6225400e5958eca5bc1c1b2539e4b511020af2c268b4d955f3a05bffbaa7db"
    sha256 arm64_ventura:  "50d14af6225ba943a9fda88ddfa7527525ace16d00fa6a67bb47a58bde2bad17"
    sha256 arm64_monterey: "8613d58abe525cbea2a46d918013fc2372666dd3a158c49d71cc44c82aaad340"
    sha256 arm64_big_sur:  "1c4886501c3137bf93f3afcb374fd4b218a37e2aa36fb1065e43753ebbb162a9"
    sha256 sonoma:         "c7d9ad175da2501a8249a95d77e9c755b8decd26cb744f839bdc5b17176c82a6"
    sha256 ventura:        "520ecff48dd7c1a31ac7c3fa9c12c91804778ff921a5bae42e8076e0fb2e4fdb"
    sha256 monterey:       "48abfb18ba86f14dd9698399b13e22771b2888077523804adfab8e6bae31b64f"
    sha256 big_sur:        "d9f3ac52eec8c99b8b9474d5e7eb53fb9cdb012bd377ffbed78db87b0e465c47"
    sha256 catalina:       "23694919d46c474b8c12d69d2e980d08f96f6bface62a74be7b8554de532e871"
    sha256 mojave:         "dd723c7394954fe354044bbd6bbea955e985c4652f0d2e7e9a7696da87d7a3aa"
    sha256 high_sierra:    "6470326d4c4d4d9a459407ec73a6ea6a2d6d2d459fb547467584dcf4e777aea8"
    sha256 sierra:         "9ace00b3ee94dbd63c427910c5aff77935f04bb884047061c792d6e90836a380"
    sha256 el_capitan:     "a209fa62fdb84a86784de5eb9699a9a6811c962afab2ebf418b2a712f51852d8"
    sha256 arm64_linux:    "2c17d11fad21ee6b273e754d76564b0213376df0a9699f66d9a30111cc3d6c63"
    sha256 x86_64_linux:   "14fcc181d3ded3aae77cb94d6667b04c81c2dd46981529b40c8fa765b794b98f"
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end