class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20240819.tgz"
  sha256 "6e1fde8ee7ad8a5c15382316863fd6b4c6d23fab781dd5ab0177ffa3ee9aae5c"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b909ad5d59d6d8ea70bb34ff898bfd6c96a5a1e3526996320033cfa2012c79eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46d31aac577fc4cfe955a4f5c4e6a84701a53280cc0db8fc49ec2a05d4a2ab2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db5f5001ae4e3298474c1bf3c931ef405b200f3fe13a95ae77bb500e95c40dd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "da06fbbbd3a1a453db1767ac80bd83ccc8a3598e0557f836a52dbb70cb1a9f41"
    sha256 cellar: :any_skip_relocation, ventura:        "04eb27368fccac1a4e6656eadedcc29fe4a6db9c7b35a3ea27910263567ae058"
    sha256 cellar: :any_skip_relocation, monterey:       "742aec50aa51412f356edef9ae1fe6bdc042e8d85310a6b922b445e819e47d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b127e2aef4d1e96aa1a9206d5b7b3ba367dcd442987e304fc403d687150da95"
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