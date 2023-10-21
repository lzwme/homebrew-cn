class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://ghproxy.com/https://github.com/gnuradio/volk/releases/download/v3.0.0/volk-3.0.0.tar.gz"
  sha256 "797c208bd449f77186684c9fa368cc8577fb98ce3763db5de526e6809de32d28"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "0cc483d3b627ca413559e042ec8490e72e4e89b94b1ce9e843abc1f265402d11"
    sha256 arm64_ventura:  "cd4bd7224339fe505ba92c6499e293e2e09ff1bd92f7ec59bd8b1b1c435bfcb4"
    sha256 arm64_monterey: "6f5a4f9da3f8e68634a37d8424d3ea7932f2c35c096f83363eb00aaa84f41fba"
    sha256 sonoma:         "11bd508d48a3ee05c2bae2e03227a26172b1c1eaf8caea047ad03e784798e68a"
    sha256 ventura:        "502c305f3ef12668a78187baec9fff3932ab7ff4d449a12153d49e157f3f9e71"
    sha256 monterey:       "33435c0f6c14b6b473ebd62217b64e8d0cce837057eb0c2af8d5f1613189bd25"
    sha256 x86_64_linux:   "05a6f706e27f0089342f093168e0112c8005128ea171d297f3093285d1ccdeed"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "orc"
  depends_on "pygments"
  depends_on "python-markupsafe"
  depends_on "python@3.12"

  on_intel do
    depends_on "cpu_features"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  def install
    python = "python3.12"

    # Set up Mako
    venv_root = libexec/"venv"
    ENV.prepend_create_path "PYTHONPATH", venv_root/Language::Python.site_packages(python)
    venv = virtualenv_create(venv_root, python)
    venv.pip_install resources

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    # cpu_features fails to build on ARM macOS.
    args = %W[
      -DPYTHON_EXECUTABLE=#{venv_root}/bin/python
      -DENABLE_TESTING=OFF
      -DVOLK_CPU_FEATURES=#{Hardware::CPU.intel?}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Set up volk_modtool paths
    site_packages = prefix/Language::Python.site_packages(python)
    pth_contents = "import site; site.addsitedir('#{site_packages}')\n"
    (venv_root/Language::Python.site_packages(python)/"homebrew-volk.pth").write pth_contents
  end

  test do
    system "#{bin}/volk_modtool", "--help"
    system "#{bin}/volk_profile", "--iter", "10"
  end
end