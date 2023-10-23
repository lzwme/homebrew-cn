class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://ghproxy.com/https://github.com/ledger/ledger/archive/v3.3.2.tar.gz"
  sha256 "555296ee1e870ff04e2356676977dcf55ebab5ad79126667bc56464cb1142035"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b0dc74b62b52e5d980aedf03a7f35155450d928cb0bfcfbadeeb1402236bf868"
    sha256 cellar: :any,                 arm64_ventura:  "70313b14bf52c7721fbcaccf2d3ad81be89faec6230f69632842362f52227cf7"
    sha256 cellar: :any,                 arm64_monterey: "0b9c0c3b030ff2d1e90f12bcda638cd991fe0a2454d20ee8c466c468910161d3"
    sha256 cellar: :any,                 sonoma:         "93309f297cb3a9931db80633b66e575282104699f46d683afa29775e190d278b"
    sha256 cellar: :any,                 ventura:        "1615ec32941999e6596e2455ddc12043e9ac1fcd4b385bd161820e3fa72ee076"
    sha256 cellar: :any,                 monterey:       "23322a8bda67c6fd6bac3ff2603a61df5eaebe376c4767095cb5c29d6e6938e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c2527a7f03514d652d5b7f68483fb048b1fe1c451e23441e1c46031f2802de5"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "mpfr"
  depends_on "python@3.11"

  uses_from_macos "libedit"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

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