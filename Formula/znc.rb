class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.2.tar.gz"
  sha256 "ff238aae3f2ae0e44e683c4aee17dc8e4fdd261ca9379d83b48a7d422488de0d"
  license "Apache-2.0"
  revision 8

  bottle do
    sha256 arm64_ventura:  "16c2edd8071636add21601f3382154a373b3c7b7b50cdda1a91257da87630011"
    sha256 arm64_monterey: "0c2589f787f5c2fd5e18bec2c1632c74dc0aae93addeebf6511dfea72a3cdd90"
    sha256 arm64_big_sur:  "219691320c4bb76f4fb7ad672e80ff4617f7a5ce54c3b8958dc43c2c22e1b5a4"
    sha256 ventura:        "fd1eca2b1aed01a8b8b7cdfb00f1ebc49144479443cfe67a7122adb587fa4e41"
    sha256 monterey:       "68b8e8ee8550fba79e05d536dcd4108c9170b50fb811bf84d5e5e543ad0088a8"
    sha256 big_sur:        "98f0e6041e53da494c149f59c0dee77a88d34964d27c7532d1b9e9166e437892"
    sha256 x86_64_linux:   "56e2e24fcb719c52a63136cb9d41d7b13a70d3f2339ef4acbf90fe08ad173cdb"
  end

  head do
    url "https://github.com/znc/znc.git", branch: "master"

    depends_on "cmake" => :build
    depends_on "swig" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  uses_from_macos "zlib"

  def install
    python3 = "python3.11"
    xy = Language::Python.major_minor_version python3

    ENV.cxx11
    # These need to be set in CXXFLAGS, because ZNC will embed them in its
    # znc-buildmod script; ZNC's configure script won't add the appropriate
    # flags itself if they're set in superenv and not in the environment.
    ENV.append "CXXFLAGS", "-std=c++11"
    ENV.append "CXXFLAGS", "-stdlib=libc++" if ENV.compiler == :clang

    if OS.linux?
      ENV.append "CXXFLAGS", "-I#{Formula["zlib"].opt_include}"
      ENV.append "LIBS", "-L#{Formula["zlib"].opt_lib}"
    end

    if build.head?
      system "cmake", "-S", ".", "-B", "build",
                      "-DWANT_PYTHON=ON",
                      "-DWANT_PYTHON_VERSION=python-#{xy}",
                      *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    else
      system "./configure", "--prefix=#{prefix}", "--enable-python=python-#{xy}"
      system "make", "install"

      # Replace dependencies' Cellar paths with opt paths
      inreplace [bin/"znc-buildmod", lib/"pkgconfig/znc.pc"] do |s|
        s.gsub! Formula["icu4c"].prefix.realpath, Formula["icu4c"].opt_prefix
        s.gsub! Formula["openssl@1.1"].prefix.realpath, Formula["openssl@1.1"].opt_prefix
      end
    end
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