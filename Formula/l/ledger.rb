class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://ghproxy.com/https://github.com/ledger/ledger/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "555296ee1e870ff04e2356676977dcf55ebab5ad79126667bc56464cb1142035"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "248d392147c9c0cb22291b9d10335e67d43afeebfadf0f10eae92d20d54896ed"
    sha256 cellar: :any,                 arm64_ventura:  "b259e7568ab75cf1cca681ce03daaa42a2a05dd70ccebcf1679dddc9ba3b36e0"
    sha256 cellar: :any,                 arm64_monterey: "84027e5700a4aa84bea85cffbb6ca795450cd960d91fa8e23b73787db5f9066d"
    sha256 cellar: :any,                 sonoma:         "9316cefc41ff3ce69b5f230c91446b0edf9d095a686fafea94e01d3d95c89824"
    sha256 cellar: :any,                 ventura:        "4f6e8d4df6fbe4a53a494eb171df343cc8133359a0fbf7eb046833b8a42717f9"
    sha256 cellar: :any,                 monterey:       "81dc67ce324583144d371b57225b4dac01a0c5ad6a90cb814399683822f33b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d312f365a2895f89532e50a7caf129e06dd614d4c094ffba45ae2e5fe1db87"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "mpfr"
  depends_on "python@3.12"

  uses_from_macos "libedit"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DBoost_NO_BOOST_CMAKE=ON
      -DPython_FIND_VERSION_MAJOR=3
      -DUSE_GPGME=1
    ] + std_cmake_args
    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", "#{pkgshare}/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end