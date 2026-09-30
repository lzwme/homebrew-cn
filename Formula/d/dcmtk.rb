class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dcmtk.org/en/dcmtk/", browsed: "2026-08-06"
  license "BSD-3-Clause"
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/DCMTK/dcmtk/archive/refs/tags/DCMTK-3.7.0.tar.gz"
    sha256 "5bb3ec8317dc465788bed2ca789e76d03ae5848c9381cce3b14c1a3f8b6aca56"

    # Backport support for OpenSSL 4
    patch do
      url "https://github.com/DCMTK/dcmtk/commit/2a9060b4b6670ad4db169abeac17728f56b43139.patch?full_index=1"
      sha256 "f36979e5534ff973812505e15daa1666008219cde47f7a040af08a81a3879a04"
      type :backport
    end
  end

  livecheck do
    url :head
    regex(/^dcmtk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "35122328b6f7635683bd93f87ec7588d058ba42155170b16ad5a46c1c368ca1d"
    sha256 arm64_tahoe:       "7b3b6af3c6ce50267c149f7c763ffcc4c9050e12ff4ba79bf8389fa82fc8b958"
    sha256 arm64_sequoia:     "d7a411774bc4619350b37f93ede1fbfd8fa822c373fbb5549227d32c49aec96f"
    sha256 arm64_linux:       "701aa3552e3d32f67e26cd36c6bd3a77e9aba7a62104768677ca35e6c860eaf1"
    sha256 x86_64_linux:      "6ae579320a406131f5603c9860d6340ce5275940dc6a737d22e92585c4f8dcde"
  end

  depends_on "cmake" => :build

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@4"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = std_cmake_args + ["-DDCMTK_WITH_ICU=OFF"]

    system "cmake", "-S", ".", "-B", "build/shared", *args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args,
                    "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/*.a"]

    inreplace lib/"cmake/dcmtk/DCMTKConfig.cmake", "#{Superenv.shims_path}/", ""
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end