class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  license "LGPL-3.0-or-later"
  revision 3
  compatibility_version 1
  head "https://github.com/gnuradio/volk.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/gnuradio/volk/releases/download/v3.3.0/volk-3.3.0.tar.gz"
    sha256 "89d11c8c8d4213b1b780354cfdbda1fed0c0b65c82847e710638eb3e21418628"

    # Fix compatibility with fmt 12.2+
    patch do
      url "https://github.com/gnuradio/volk/commit/5620097efb4a70620259000d27918dee1d03ee1e.patch?full_index=1"
      sha256 "18e6515ce4932f93bb3e8855c16a411a4de61a6006c7a12d1ac342d5174d08ba"
      type :backport
      resolves "https://github.com/gnuradio/volk/pull/869"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "064a12142b6a5db630acdc6ad43739178ec1e5e92ae45d02546c1a691edf743e"
    sha256 cellar: :any, arm64_tahoe:       "537a5468aeee011491cee324d7515d0e70309e8184b41af722ef049f0bcb50e9"
    sha256 cellar: :any, arm64_sequoia:     "171af672ac4f4c50f1aca6c9e675e33774d2c2908f53720ec057dd0fbe3c7e0c"
    sha256 cellar: :any, arm64_linux:       "6b8c1758e38fc748a047f67bfe5a2078cf3dd4893737c8fd591d2b5905b32866"
    sha256 cellar: :any, x86_64_linux:      "8db67d0983446bd027566318c8debcc4058bc45eaef61dc5e8f06fb769d99eba"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cpu_features"
  depends_on "fmt"
  depends_on "orc"
  depends_on "python@3.14"

  conflicts_with "vulkan-volk", because: "both install volkConfig.cmake"

  pypi_packages package_name:   "",
                extra_packages: "mako"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # Avoid falling back to bundled cpu_features
    rm_r(buildpath/"cpu_features")

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python3}",
                    "-DENABLE_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"volk_modtool", "--help"
    system bin/"volk_profile", "--iter", "10"
  end
end