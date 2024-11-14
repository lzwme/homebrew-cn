class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.9.1.tar.gz"
  sha256 "e8a7cf80e19aad510b4e282eaf61b56bc30df88ea2e0f64fadcdd303c4894f3c"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "47a4377429c552b85f0f0d01c4bd626c16b870b25e5c236b3638d7d364b8515f"
    sha256 arm64_sonoma:  "cd03c571acd62e9278b6a4a516e8eb62e4b6094c3207130b6bae9aa8e15e022b"
    sha256 arm64_ventura: "8d500898246859202ec756125592c33b07419d7d42e19ec739d3cdb7a87d6339"
    sha256 sonoma:        "f7d4596fc318adca1268a55c3e0d065999e69dedc7b55f84b89a72cb8fb1ae51"
    sha256 ventura:       "ab19a326ac21a984ff8e0594239d567d8bbe9c793566040d54d283eefd8c37b4"
    sha256 x86_64_linux:  "0da654df490b1c2eb22af53ec756b181d5116006b24ecb78451a325812929a14"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "icu4c@76"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "zlib"

  def install
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
    assert_predicate testpath/".znc/znc.pem", :exist?
  end
end