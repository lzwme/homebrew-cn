class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https:wiki.znc.inZNC"
  url "https:znc.inreleasesarchiveznc-1.9.0.tar.gz"
  sha256 "8b99c9dbb21c1309705073460be9bfacb6f7b0e83a15fe5d4b7140201b39d2a1"
  license "Apache-2.0"
  head "https:github.comzncznc.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "dddb735c0994729e2fc6b5deda68bcc2bb06cdc3926ccfdd177ce127c7d31d22"
    sha256 arm64_ventura:  "dd925bb118aad946bc8084496bc9bd7239c2e79f8b570d0a97935f8aab40c898"
    sha256 arm64_monterey: "f3aef8b836efba54d66cfd66c0b05e881037bd5c35a86547ecc3a30cc16da395"
    sha256 sonoma:         "103a97cfa35fed90a013b4c06110cc3b158d96cd58c614d30dee0d69e298ced2"
    sha256 ventura:        "37087530395d80131f237ee2e38ab8d16a5a86a11d08a53eccf80f7b675148a4"
    sha256 monterey:       "d9babb7b092c38406170cf5ce4010649886505b2b5edb35dee5aafafa14e5820"
    sha256 x86_64_linux:   "b448547a7c46c1d0ae1b59e6f66608e226e8af796045b1d56c748cfee62fdcf1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "zlib"

  def install
    python3 = "python3.12"
    xy = Language::Python.major_minor_version python3

    # Fixes: CMake Error: Problem with archive_write_header(): Can't create 'swigpyrun.h'
    ENV.deparallelize

    system "cmake", "-S", ".", "-B", "build",
                    "-DWANT_PYTHON=ON",
                    "-DWANT_PYTHON_VERSION=python-#{xy}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    inreplace lib"pkgconfigznc.pc", Superenv.shims_pathENV.cxx, ENV.cxx
  end

  service do
    run [opt_bin"znc", "--foreground"]
    run_type :interval
    interval 300
    log_path var"logznc.log"
    error_log_path var"logznc.log"
  end

  test do
    mkdir ".znc"
    system bin"znc", "--makepem"
    assert_predicate testpath".zncznc.pem", :exist?
  end
end