class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.10.0.tar.gz"
  sha256 "be65ad9b62ef545a7e9486f2f74134edc53ba513ad43a69d9d8b476605336b19"
  license "Apache-2.0"

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "faf787077613c0a36560ef87b3d9e295361815f3ab50c2d14b2cbe69aa5ee48d"
    sha256 arm64_sonoma:  "960b6ccae0fd3bac57b981ec9af1749bb3f4f20c1a2d1188619c582d5cbe0037"
    sha256 arm64_ventura: "6ca436e507d85d2b09625a0f8ad8ff35c3db021905d86ae7317c1d2ebb6d8fe3"
    sha256 sonoma:        "8a37ddfbd4ad63c0d2abbb216c38832782b2c4934f92b7508bd5f230684401a3"
    sha256 ventura:       "f868412a89bebfb4afc6df9ca030f220e282f37ee0e203596b4cdb27503f19ba"
    sha256 arm64_linux:   "e99d9f71bd7968ac63a074722e266fc2e1bec3693319afd05631c9eee514dcf3"
    sha256 x86_64_linux:  "40c2f441fd3404f732815e461d87f8e1d630bce7d695fd1e6b91972cc6de6c22"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@77"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "zlib"

  def install
    rm_r(["third_party/cctz", "third_party/googletest"])

    python3 = "python3.13"
    xy = Language::Python.major_minor_version python3

    # Fixes: CMake Error: Problem with archive_write_header(): Can't create 'swigpyrun.h'
    ENV.deparallelize

    args = %W[
      -DWANT_PYTHON=ON
      -DWANT_PYTHON_VERSION=python-#{xy}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    inreplace lib/"pkgconfig/znc.pc", Superenv.shims_path/ENV.cxx, ENV.cxx
  end

  service do
    run [opt_bin/"znc", "--foreground"]
    run_type :interval
    interval 300
    log_path var/"log/znc.log"
    error_log_path var/"log/znc.log"
  end

  test do
    mkdir ".znc"
    system bin/"znc", "--makepem"
    assert_path_exists testpath/".znc/znc.pem"
  end
end