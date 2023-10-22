class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.3.0.tar.gz"
  sha256 "bbff2a754c26f525596c0926eb2198992e1e2eac5b9bc9cbe31e302875de6278"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b43a95dc2dd1987cb2ef75a1633565cf637ca674efa69c09a2c4b9efe6d94bb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23602fc20ca32334c64448fbbdb9bedebb8e3fb1bb8a37e00bba030e5346289c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0d2b97f492325454c3ae44f0ea65c3fbd16f9cc88b8a8085af786c990eb8a3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "00902c54178fea26994c694cb15007575ead744940e24402960448efbdd2c52d"
    sha256 cellar: :any_skip_relocation, ventura:        "8f944e4c52824ad72b2ff77134264b8e652e275f9b624f2029403e545650cf44"
    sha256 cellar: :any_skip_relocation, monterey:       "8b418bb68d9fd4e67e6b4ba6429e0a31ee248ce70644526e56b21a761d6bf7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a138389f107fb5523e226407f48921b61285dd480c8c0dc3dd2e4bca8cfb2120"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"test").install %w[test/progfree.f.in test/progfree.f.try.f.ref]
  end

  test do
    cp_r pkgshare/"test/progfree.f.in", testpath
    cp_r pkgshare/"test/progfree.f.try.f.ref", testpath
    flags = File.open(testpath/"progfree.f.in", &:readline).sub(/ *! */, "").chomp
    system "#{bin}/findent #{flags} < progfree.f.in > progfree.f.out.f90"
    assert_predicate testpath/"progfree.f.out.f90", :exist?
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end