class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20231126.tgz"
  sha256 "1ac1e106e2880d9f6579ad993217f4af3b6de9943f90099c8d00668cbecb4367"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "992949bcd62778486035e59586947e8ab8e974ba495beae54dc4e4903d9c3430"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf54417a82f8065eb4abcaef52f67cc59e05befef36d95b336f8c90f7471f2ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1605bb31c6b20de8a39a7cb9cee930b2d4f01e057fe619c468ac58f99cf5c28"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1e66c467362d985223004225a79636e5ea748ad3a34daf6553d3651bf365a4d"
    sha256 cellar: :any_skip_relocation, ventura:        "e708e4862bae2e4bb63c78c18c265a728a1cad796cc462b89e370ccce0c51e9c"
    sha256 cellar: :any_skip_relocation, monterey:       "dc14e7eed1dab492dd9d4a2c7643cf4544d9919e479a79d3d149e0873ce200fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cff533948615b80e54836fed4aa2aa33c0a5b385cc7b20fed7f1b58e289d561"
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