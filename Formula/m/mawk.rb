class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20231102.tgz"
  sha256 "1721c6949bd0d7a4bcf4924c1ff244b4be02a4e58a8b2a6ecbeb935ad0fd700a"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73e460b3046dffbaffe4f8ad9a91b00288b3eaa3927cbf37a3278a7220235305"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd68b241a5dd0222ebc4af26549d042af73439529b8b4d370b43db2c6accbe6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f51bc8dd6b4cbb65b7fc1a51248ca3b2894ffc4769fc47389cd352a24b0f43a"
    sha256 cellar: :any_skip_relocation, sonoma:         "89eb2c1d5855880233cee581e7bf1846940cc3c2e26d919ab271c4a5e2d7aea7"
    sha256 cellar: :any_skip_relocation, ventura:        "4e548a40f124a8dd0b09b0df0ef68bdfff98f23c1fee5b07efa7bc26547a9321"
    sha256 cellar: :any_skip_relocation, monterey:       "bdc1f84d290546e42cf4836584b902541f1b85b95cac74d2615814e32d74cddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec5f27c68bcf888d4f979bed3c25bcbb89e15087415742f5eb03e516ad70af5a"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end