class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https:ledger-cli.org"
  license "BSD-3-Clause"
  revision 5
  head "https:github.comledgerledger.git", branch: "master"

  stable do
    url "https:github.comledgerledgerarchiverefstagsv3.3.2.tar.gz"
    sha256 "555296ee1e870ff04e2356676977dcf55ebab5ad79126667bc56464cb1142035"

    # Support building with mandoc
    # Remove with v3.4.x
    patch do
      url "https:github.comledgerledgercommitf40cee6c3af4c9cec05adf520fc7077a45060434.patch?full_index=1"
      sha256 "d5be89dbadff7e564a750c10cdb04b83e875452071a2115dd70aae6e7a8ee76c"
    end
    patch do
      url "https:github.comledgerledgercommit14b90d8d952b40e0a474223e7f74a1e6505d5450.patch?full_index=1"
      sha256 "d250557e385163e3ad3002117ebe985af040d915aab49ae1ea342db82398aeda"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "60ac96b0bfcb2426e6b3aaf06469abb779ec0cd62ce1a17aa7bf7662b2431059"
    sha256 cellar: :any,                 arm64_ventura:  "9b7a4add3841f03fff22581461f97a641f6c2bad4aead31591dff19b356a7fa4"
    sha256 cellar: :any,                 arm64_monterey: "3eb4fb8697fe8c348e37928eda6960d00f784f65a244cdf96609c8fd48335a99"
    sha256 cellar: :any,                 sonoma:         "83c694de6d2cd94909106e1f30a11ade60d22093e6d654599a0433f508b07d8c"
    sha256 cellar: :any,                 ventura:        "4a699b36e5d09a6f928c4a3b1eea44ac474ab897f9bb9099a86f8950d8172dc1"
    sha256 cellar: :any,                 monterey:       "f1c7bcf2452c2cf15d063ddf01db53e534240c1b782dd10ac3fd88cbc129dada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd2794ce3d53f5ac6694a58d08a63b84a9dc679c61b03f8434dc9f7842a98b76"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "mpfr"
  depends_on "python@3.12"

  uses_from_macos "mandoc" => :build
  uses_from_macos "libedit"

  # Fix build with `boost` 1.85.0 using open PR.
  # PR ref: https:github.comledgerledgerpull2337
  patch do
    url "https:github.comledgerledgercommit1da89f6ffb44a44257b9774c4ceb71e7b495d677.patch?full_index=1"
    sha256 "8aaf8daf4748f359946c64488c96345f4a4bdf928f6ec7a1003610174428599f"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec"bin"

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
    system ".acprep", "opt", "make", *args
    system ".acprep", "opt", "make", "doc", *args
    system ".acprep", "opt", "make", "install", *args

    (pkgshare"examples").install Dir["testinput*.dat"]
    pkgshare.install "contrib"
    elisp.install Dir["lisp*.el", "lisp*.elc"]
    bash_completion.install pkgshare"contribledger-completion.bash"
  end

  test do
    balance = testpath"output"
    system bin"ledger",
      "--args-only",
      "--file", "#{pkgshare}examplessample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end