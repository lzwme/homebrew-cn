class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://ghfast.top/https://github.com/ledger/ledger/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "1d60b5c78631bbea49bf8201234c15ff9c7e9f2df18d97d27080c8922eae3e13"
  license "BSD-3-Clause"
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e96abc8492a071cd6441cdbeae1ad33cc0184c94de491a49c57b23148e22e25"
    sha256 cellar: :any,                 arm64_sequoia: "40777f10d2110be733c2920ecba940a3f9d491544f948616fac0cf5814faf341"
    sha256 cellar: :any,                 arm64_sonoma:  "8eab5c82b961be1dc8f910b29d1fc3ffc3e66262541875aac78c8fb0937abd5d"
    sha256 cellar: :any,                 sonoma:        "1ac648ddcafe40bc89e8beda2b938012bbbd42607d411ef569658d207491a315"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bd9b045083793d5198957c9f8427fca690d081a6775c1c6cc63bb5db4427193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe6bc51c5763fa6f04c378ef2e82b21a92592bda8fdd64a52a3e1aff0e07b0f"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "gpgmepp"
  depends_on "mpfr"
  depends_on "python@3.14"

  uses_from_macos "mandoc" => :build
  uses_from_macos "libedit"

  on_macos do
    depends_on "libassuan"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"

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
      -DCMAKE_CXX_STANDARD=14
    ] + std_cmake_args

    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash" => "ledger"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", pkgshare/"examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
  end
end