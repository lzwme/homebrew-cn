class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20230730.tgz"
  sha256 "810b7cc0aa2bff5ff215f237e275b327b21ba49a0d7b36930e3ddc80f4ce5618"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c939fe91125060074c2032a980be5b5b9e581b4914e060ab951723a400b1e9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fadae126af3d704ae320bd83f72d7ff7a0435c489185b8664c2e5db8513c37d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2bfdec288814d47c5c020511e8dda1c8206d73e79a93ce2d5f5493bcd98e810"
    sha256 cellar: :any_skip_relocation, ventura:        "f95e8c18ba05347f1c2b87b53007610b3f898b3e48e06d0855150fb29f02e6a1"
    sha256 cellar: :any_skip_relocation, monterey:       "9c44c274e892834f9f2f8973eb34acd894dc3bf9e58b0eef4d09b8144f836952"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdfe4d4c3a0c96b47b656cf8c148eca90bbb0798ae85f8f23f6198cb1d0b7944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01de486df9ba98a51acc75eb599152bc67016742f2029ad80ef3b0d54a02f7f7"
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