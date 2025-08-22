class Ola < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Open Lighting Architecture for lighting control information"
  homepage "https://github.com/OpenLightingProject/ola"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 7

  stable do
    # TODO: Check if we can use unversioned `protobuf` at version bump
    url "https://ghfast.top/https://github.com/OpenLightingProject/ola/releases/download/0.10.9/ola-0.10.9.tar.gz"
    sha256 "44073698c147fe641507398253c2e52ff8dc7eac8606cbf286c29f37939a4ebf"

    # fix liblo 0.32 header compatibility
    # upstream pr ref, https://github.com/OpenLightingProject/ola/pull/1954
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/e083653d2d18018fe6ef42f757bc06462de87f28.patch?full_index=1"
      sha256 "1276aded269497fab2e3fc95653b5b8203308a54c40fe2dcd2215a7f0d0369de"
    end

    # Backport fix for protoc version detection
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/aed518a81340a80765e258d1523b75c22a780052.patch?full_index=1"
      sha256 "7e48c0027b79e129c1f25f29fae75568a418b99c5b789ba066a4253b7176b00a"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sonoma:  "0abe0cdf444f19e95d108975b4e922392a53bd04aee0809f8b38d2c65dbc2119"
    sha256 arm64_ventura: "689becd3e9be5eaac2153c7b54d95aca51ed20887f7ef8e930ec65abdff7d40b"
    sha256 sonoma:        "8c85e29a677be1c7d729f27821cd340e258fafc3e7c341e14cf2dc887973f7de"
    sha256 ventura:       "576d9e927f6a14c88e142399d8261ad50ebe4d45f9ae6e517693fbfc3a4d6152"
    sha256 arm64_linux:   "35a522a13c6bd31eaa934ee2268f89719c94bd8054af06d1cc9d692ba081daee"
    sha256 x86_64_linux:  "a5691c9b8d2c0a7c797f0a683da77cc1a604bf9dd37a65aca1bf0507ace71209"
  end

  head do
    url "https://github.com/OpenLightingProject/ola.git", branch: "master"

    # Apply open PR to fix macOS HEAD build
    # PR ref: https://github.com/OpenLightingProject/ola/pull/1983
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/b8134b82e15f19266c79620b9c3c012bc515357d.patch?full_index=1"
      sha256 "d168118436186f0a30f4f7f2fdfcde69a5d20a8dcbef61c586d89cfd8f513e33"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build # TODO: remove once we no longer need to run tests
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "abseil"
  depends_on "liblo"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "numpy"
  depends_on "protobuf@29"
  depends_on "python@3.13"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/43/29/d09e70352e4e88c9c7a198d5645d7277811448d76c23b00345670f7c8a38/protobuf-5.29.5.tar.gz"
    sha256 "bc1463bafd4b0929216c35f437a8e28731a2b7fe3d98bb77a600efced5a15c84"
  end

  # Apply open PR to support Protobuf 22+ API
  # PR ref: https://github.com/OpenLightingProject/ola/pull/1984
  patch do
    url "https://github.com/OpenLightingProject/ola/commit/4924c9908ea879b36dc9132768fca25f6f21a677.patch?full_index=1"
    sha256 "4d3ed12a41d4c2717cfbb3fa790ddf115b084c1d3566a4d2f0e52a8ab25053ef"
  end

  def python3
    "python3.13"
  end

  def extra_python_path
    opt_libexec/Language::Python.site_packages(python3)
  end

  def install
    # Workaround to build with newer Protobuf due to Abseil C++ standard
    # Issue ref: https://github.com/OpenLightingProject/ola/issues/1879
    inreplace "configure.ac", "-std=gnu++11", "-std=gnu++17"
    if ENV.compiler == :clang
      # Workaround until https://github.com/OpenLightingProject/ola/pull/1889
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR"
      # Workaround until https://github.com/OpenLightingProject/ola/pull/1890
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_BINDERS"
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_UNARY_BINARY_FUNCTION"
    end

    # Skip flaky python tests. Remove when no longer running tests
    inreplace "python/ola/Makefile.mk", /^test_scripts \+= \\$/, "skipped_test_scripts = \\"
    # Skip flaky tests on macOS
    if OS.mac?
      # https://github.com/OpenLightingProject/ola/pull/1655#issuecomment-696756941
      inreplace "common/network/Makefile.mk", %r{\bcommon/network/HealthCheckedConnectionTester }, "#\\0"
      inreplace "plugins/usbpro/Makefile.mk", %r{\\\n\s*plugins/usbpro/WidgetDetectorThreadTester$}, ""
      # TODO: SelectServerTester may need confirmation on sporadic failures.
      inreplace "common/io/Makefile.mk", %r{\bcommon/io/SelectServerTester }, "#\\0"
    end

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    args = %W[
      --disable-fatal-warnings
      --disable-silent-rules
      --enable-unittests
      --enable-python-libs
      --enable-rdm-tests
      --with-python_prefix=#{libexec}
      --with-python_exec_prefix=#{libexec}
    ]

    ENV["PYTHON"] = venv.root/"bin/python"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make"
    # Run tests to check the workarounds applied haven't broken basic functionality.
    # TODO: Remove and revert to `--disable-unittests` when workarounds can be dropped.
    ENV.deparallelize do
      system "make", "check"
    ensure
      logs.install buildpath/"test-suite.log" if (buildpath/"test-suite.log").exist?
    end
    system "make", "install"

    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  def caveats
    <<~EOS
      To use the bundled Python libraries:
        #{Utils::Shell.export_value("PYTHONPATH", extra_python_path)}
    EOS
  end

  test do
    ENV.prepend_path "PYTHONPATH", extra_python_path
    system bin/"ola_plugin_state", "-h"
    system python3, "-c", "from ola.ClientWrapper import ClientWrapper"
  end
end