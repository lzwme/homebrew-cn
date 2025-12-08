class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-6.5.tar.xz"
  sha256 "56a6f934f5d2ded57206d2f109975324b39586394f4e8ce23b3c72aadcd5cd4a"
  license "GPL-3.0-or-later"
  head "https://git.dynare.org/Dynare/dynare.git", branch: "master"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "5a66deb7887ad8c8d7d6fbb9a31f00de647eaa7988d5553599d60007ccf6b748"
    sha256 cellar: :any, arm64_sequoia: "d4cb3df682a5246291b44896984983bacf416f5f48f2414538b3cf99447b5cef"
    sha256 cellar: :any, arm64_sonoma:  "1815fcb8d7bd00d26287027f80c4ee8b05c85e65297670d7daccad3e59985029"
    sha256 cellar: :any, sonoma:        "af541cbb7df48ac4cd82ea524d2044c34efa6f4f96672e915ba188827483a304"
    sha256               arm64_linux:   "5a4a6414768cb0bacf17892f693f8645e589b58996a582d4bd0530909207913f"
    sha256               x86_64_linux:  "500a3346e13e46eb9ec0e7c20ca8d035bef694ae026f4e1b6c4c2848b7549668"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gcc" # for gfortran
  depends_on "gsl"
  depends_on "libmatio"
  depends_on "octave"
  depends_on "openblas"
  depends_on "slicot"
  depends_on "suite-sparse"

  fails_with :clang do
    cause <<~EOS
      GCC is the only compiler supported by upstream
      https://git.dynare.org/Dynare/dynare/-/blob/master/README.md#general-instructions
    EOS
  end

  def install
    # This needs a bit of extra help in finding the Octave libraries on Linux.
    octave = Formula["octave"]
    ENV.append "LDFLAGS", "-Wl,-rpath,#{octave.opt_lib}/octave/#{octave.version.major_minor_patch}" if OS.linux?

    # Help meson find `boost` and `suite-sparse`
    ENV["BOOST_ROOT"] = Formula["boost"].opt_prefix
    ENV.append_path "LIBRARY_PATH", Formula["suite-sparse"].opt_lib

    system "meson", "setup", "build", "-Dbuild_for=octave", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (pkgshare/"examples").install "examples/bkk.mod"
  end

  def caveats
    <<~EOS
      To get started with Dynare, open Octave and type
        addpath #{opt_lib}/dynare/matlab
    EOS
  end

  test do
    resource "statistics" do
      url "https://ghfast.top/https://github.com/gnu-octave/statistics/archive/refs/tags/release-1.7.3.tar.gz", using: :nounzip
      sha256 "570d52af975ea9861a6fb024c23fc0f403199e4b56d7a883ee6ca17072e26990"
    end

    ENV.delete "CXX" # avoid overriding Octave flags
    ENV.delete "LDFLAGS" # avoid overriding Octave flags

    statistics = resource("statistics")
    testpath.install statistics

    cp pkgshare/"examples/bkk.mod", testpath

    # Replace `makeinfo` with dummy command `true` to prevent generating docs
    # that are not useful to the test.
    (testpath/"dyn_test.m").write <<~MATLAB
      makeinfo_program true
      pkg prefix #{testpath}/octave
      pkg install statistics-release-#{statistics.version}.tar.gz
      dynare bkk.mod console
    MATLAB

    system Formula["octave"].opt_bin/"octave", "--no-gui",
           "--no-history", "--path", "#{lib}/dynare/matlab", "dyn_test.m"
  end
end