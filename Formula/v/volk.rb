class Volk < Formula
  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://ghproxy.com/https://github.com/gnuradio/volk/releases/download/v3.0.0/volk-3.0.0.tar.gz"
  sha256 "797c208bd449f77186684c9fa368cc8577fb98ce3763db5de526e6809de32d28"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 arm64_sonoma:   "072cd45e79c9ac4963295c6fdfef3cff48896f6becef6ac7b8231435a89440f2"
    sha256 arm64_ventura:  "912e1ea863bf9f6826659452f24d397858d54406c5fa54a006c77a7144199625"
    sha256 arm64_monterey: "f72f8a5caa0dea45ed68270de221f572c55912d0166da58d604db2d857a94fda"
    sha256 sonoma:         "0edaf57d20141a964fff36c396f96a6b6c885ea11066693c4c52c0f5cc7d0db1"
    sha256 ventura:        "5f299db3defa0020c8f7ea479af41ff16648f0dfb117f87f652cd61afc3a0e8b"
    sha256 monterey:       "33f296f46eedd9352a5c5fecd2fdd86b68941ef4589ab0ea0de56b13ce877616"
    sha256 x86_64_linux:   "57c61351a927713042c5cf0d71fe440ff758cc072cb0e2d81f98a8b8b0508abe"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "orc"
  depends_on "pygments"
  depends_on "python-mako"
  depends_on "python-markupsafe"
  depends_on "python@3.12"

  on_intel do
    depends_on "cpu_features"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  def install
    python = "python3.12"

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    # cpu_features fails to build on ARM macOS.
    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python)}
      -DENABLE_TESTING=OFF
      -DVOLK_CPU_FEATURES=#{Hardware::CPU.intel?}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/volk_modtool", "--help"
    system "#{bin}/volk_profile", "--iter", "10"
  end
end