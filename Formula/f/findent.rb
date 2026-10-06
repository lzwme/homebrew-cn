class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.4.1.tar.gz"
  mirror "https://www.ratrabbit.nl/downloads/findent/findent-4.4.1.tar.gz"
  sha256 "4a44b52cb111c4fdf88752430d20041150fbb5b60f9edac3a2fd513ddc96d1ed"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ab0aa33d7f954a2be3a4e2f56ebc55ca565b589eac403ae9b66f3659da7585e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f9b14f57b8752eac97bfd8f17d587e3d247913f9264ed2e83c12be1c9dc7d20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e37dfb46ff57e8245d01cbfbbe88ed18c2ba042ab1e9b7ac0e8e7e7ac766457"
    sha256 cellar: :any,                 arm64_linux:       "72c6ebb21232a5506d22f7df38d2227f1a1c68225b6c55783cc5a33e83d7a106"
    sha256 cellar: :any,                 x86_64_linux:      "a3670e9fe92352e5f2e8389a1c794c30f2b1df158229ce3495ae8e3386d98cc1"
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
    system bin/"findent #{flags} < progfree.f.in > progfree.f.out.f90"
    assert_path_exists testpath/"progfree.f.out.f90"
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end