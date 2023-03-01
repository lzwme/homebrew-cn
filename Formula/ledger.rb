class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://ghproxy.com/https://github.com/ledger/ledger/archive/v3.3.0.tar.gz"
  sha256 "42307121666b5195a122857ec572e554b77ecf6b12c53e716756c9dae20dc7c1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9b14daf25025e233e72db26bc9697e56774d83bb71eae1130b97f3906796e95a"
    sha256 cellar: :any,                 arm64_monterey: "c32cc75c88d2c4ea27d1b680f21397b27354ea184819930c07c94e937ef445d9"
    sha256 cellar: :any,                 arm64_big_sur:  "6ee16e75e6e74051de07bd1a178eb44b05749db8cb934af12d087d5a329fddd9"
    sha256 cellar: :any,                 ventura:        "a9e730b8a4958f20454ae7e8a89648663fb29b472f885136ef556fc4a42b16cc"
    sha256 cellar: :any,                 monterey:       "62cfdcd7d9f6a7f92145c4c84e6d9ae89971b0d37225f0e16960226807a5e645"
    sha256 cellar: :any,                 big_sur:        "3df65aadbb26d68f24a56c2e29c2dac86422b62e93ed1795673948f246502165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54d4654634c5ed0b145aff5be831daf8bae2b7720caadae902de38da94a4b82c"
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