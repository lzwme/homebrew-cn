class Ola < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Open Lighting Architecture for lighting control information"
  homepage "https:www.openlighting.orgola"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 4

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
    sha256                               arm64_sequoia: "da0b6d336c77add2ec88c13f7f3d1300fdd6257505240d3b6cefe32320994259"
    sha256                               arm64_sonoma:  "ca21235c13a13e393cc0792c760a094a68e68713b27a8db93c42ae58f6f8fa48"
    sha256                               arm64_ventura: "91339dd372819edaeedf7f5f2ce528c023d7d592f2df4a2e5c13bf47b8d92810"
    sha256                               sonoma:        "1d1cfc263bfa58ac6a4a789fbcf982997785664c9bd477c2192a53a8131a01cb"
    sha256                               ventura:       "ec372bbb7ab577e8b75b2ff79b2a92e90a8eecbba2083bccb7194c8698609e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3aa81849e9a64ad7ae28324c9418d12c9267828da8cf03121999dc513a0ce20"
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
    url "https:files.pythonhosted.orgpackagesa5734e6295c1420a9d20c9c351db3a36109b4c9aa601916cb7c6871e3196a1caprotobuf-5.29.2.tar.gz"
    sha256 "b2cc8e8bb7c9326996f0e160137b0861f1a82162502658df2951209d0cb0309e"
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