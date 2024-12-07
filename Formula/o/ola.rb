class Ola < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Open Lighting Architecture for lighting control information"
  homepage "https:www.openlighting.orgola"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 3

  stable do
    # TODO: Check if we can use unversioned `protobuf` at version bump
    url "https:github.comOpenLightingProjectolareleasesdownload0.10.9ola-0.10.9.tar.gz"
    sha256 "44073698c147fe641507398253c2e52ff8dc7eac8606cbf286c29f37939a4ebf"

    # fix liblo 0.32 header compatibility
    # upstream pr ref, https:github.comOpenLightingProjectolapull1954
    patch do
      url "https:github.comOpenLightingProjectolacommite083653d2d18018fe6ef42f757bc06462de87f28.patch?full_index=1"
      sha256 "1276aded269497fab2e3fc95653b5b8203308a54c40fe2dcd2215a7f0d0369de"
    end

    # Backport fix for protoc version detection
    patch do
      url "https:github.comOpenLightingProjectolacommitaed518a81340a80765e258d1523b75c22a780052.patch?full_index=1"
      sha256 "7e48c0027b79e129c1f25f29fae75568a418b99c5b789ba066a4253b7176b00a"
    end
  end

  bottle do
    sha256                               arm64_sequoia: "e1f9c63cc95850939944b13db642edf0b739537a27fc938c4aedf1f172a261d0"
    sha256                               arm64_sonoma:  "a682abb7185bc20aef2d30b30f152222ea9c5257aab744cde03aaa5583e88208"
    sha256                               arm64_ventura: "7c0dc6b427c6776c3344e26f4845a522300effb6667407db2710675e6868a668"
    sha256                               sonoma:        "d0c3934c5b288ed18add3ae23e7f015f34ea710cc4648fdecdc1b0bf619f63e5"
    sha256                               ventura:       "3de55dadd98b13f77a540dec1504b6a65fe988054aa78bc1959515f00a9c8b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caccfa95c7cb88c18365e22ec8882bc2a5152b772e386b93f5cd61396b897f0b"
  end

  head do
    url "https:github.comOpenLightingProjectola.git", branch: "master"

    # Apply open PR to fix macOS HEAD build
    # PR ref: https:github.comOpenLightingProjectolapull1983
    patch do
      url "https:github.comOpenLightingProjectolacommitb8134b82e15f19266c79620b9c3c012bc515357d.patch?full_index=1"
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
  depends_on "protobuf"
  depends_on "python@3.13"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagesd24f1639b7b1633d8fd55f216ba01e21bf2c43384ab25ef3ddb35d85a52033e8protobuf-5.29.1.tar.gz"
    sha256 "683be02ca21a6ffe80db6dd02c0b5b2892322c59ca57fd6c872d652cb80549cb"
  end

  # Apply open PR to support Protobuf 22+ API
  # PR ref: https:github.comOpenLightingProjectolapull1984
  patch do
    url "https:github.comOpenLightingProjectolacommit4924c9908ea879b36dc9132768fca25f6f21a677.patch?full_index=1"
    sha256 "4d3ed12a41d4c2717cfbb3fa790ddf115b084c1d3566a4d2f0e52a8ab25053ef"
  end

  def python3
    "python3.13"
  end

  def extra_python_path
    opt_libexecLanguage::Python.site_packages(python3)
  end

  def install
    # Workaround to build with newer Protobuf due to Abseil C++ standard
    # Issue ref: https:github.comOpenLightingProjectolaissues1879
    inreplace "configure.ac", "-std=gnu++11", "-std=gnu++17"
    if ENV.compiler == :clang
      # Workaround until https:github.comOpenLightingProjectolapull1889
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR"
      # Workaround until https:github.comOpenLightingProjectolapull1890
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_BINDERS"
      ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_UNARY_BINARY_FUNCTION"
    end

    # Skip flaky python tests. Remove when no longer running tests
    inreplace "pythonolaMakefile.mk", ^test_scripts \+= \\$, "skipped_test_scripts = \\"

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

    ENV["PYTHON"] = venv.root"binpython"
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", *args, *std_configure_args
    system "make"
    # Run tests to check the workarounds applied haven't broken basic functionality.
    # TODO: Remove and revert to `--disable-unittests` when workarounds can be dropped.
    system "make", "check"
    system "make", "install"

    rewrite_shebang python_shebang_rewrite_info(venv.root"binpython"), *bin.children
  end

  def caveats
    <<~EOS
      To use the bundled Python libraries:
        #{Utils::Shell.export_value("PYTHONPATH", extra_python_path)}
    EOS
  end

  test do
    ENV.prepend_path "PYTHONPATH", extra_python_path
    system bin"ola_plugin_state", "-h"
    system python3, "-c", "from ola.ClientWrapper import ClientWrapper"
  end
end