class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https:ledger-cli.org"
  license "BSD-3-Clause"
  revision 7
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

    # Backport fix to build with `boost` 1.85.0
    patch do
      url "https:github.comledgerledgercommit46207852174feb5c76c7ab894bc13b4f388bf501.patch?full_index=1"
      sha256 "8aaf8daf4748f359946c64488c96345f4a4bdf928f6ec7a1003610174428599f"
    end

    # Backport fixes to build with `boost` 1.86.0
    # Ref: https:github.comledgerledgerpull2381
    patch do
      url "https:github.comledgerledgercommitad93c185644cfcb14fe4a673e74a0cb5c954a4b4.patch?full_index=1"
      sha256 "3d2db6b116cd7e8a1051ac7f92853f72c145ff0487f2f4e12e650ee7ec9e67b0"
    end
    patch do
      url "https:github.comledgerledgercommit4f4cc1688a8e8a7c03f18603cc5a4159d9c89ca3.patch?full_index=1"
      sha256 "938d62974ee507b851239b6525c98c8cb1c81e24e8ae2939d4675d97a8ec8f67"
    end
    patch do
      url "https:github.comledgerledgercommit5320c9f719a309ddacdbe77181cabeb351949013.patch?full_index=1"
      sha256 "9794113b28eabdcfc8b900eafc8dc2c0698409c0b3d856083ed5e38818289ba1"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "605f9873cfeee7c954f55a29fbde7cf2066792baca747d039240a4840f40bfa5"
    sha256 cellar: :any,                 arm64_sonoma:  "a84da9d701f740f902b8c635c19f394cf2b58820a9a59219773617bad15eba19"
    sha256 cellar: :any,                 arm64_ventura: "6a3c0b722a87fb070eb270e05ca78cfded257e470166597a6766a7dbc42222b9"
    sha256 cellar: :any,                 sonoma:        "ce4e727f36f0a3159695744dceadb0362d7fbb25906152df3c8263c0c6fe59e7"
    sha256 cellar: :any,                 ventura:       "159ba0b0853efd009ad410a16bd8d2a8bdfbc4123751dff90338d810551c7e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb58b2ab66d1efffa83333d0c281280a20bdd5f6dc9b9bf5058634e58639c772"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "mpfr"
  depends_on "python@3.13"

  uses_from_macos "mandoc" => :build
  uses_from_macos "libedit"

  on_macos do
    depends_on "libassuan"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec"bin"

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
      "--file", pkgshare"examplessample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
  end
end