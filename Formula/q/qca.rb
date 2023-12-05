class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.7/qca-2.3.7.tar.xz"
  sha256 "fee2343b54687d5be3e30fb33ce296ee50ac7ae5e23d7ab725f63ffdf7af3f43"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "5c9466bc6d5d8faddf2b7e198de19384f3b2d33a4e9229d8b57792117fb45a83"
    sha256 cellar: :any,                 arm64_ventura:  "0c3bb008ccc3acdfe6bb2bbe543983214ea4a875d34b5fa7936b3957da60563a"
    sha256 cellar: :any,                 arm64_monterey: "0271ed6992af95173cdfd7e5ac6b3baa3ee73e67413dc646451879554b6614ef"
    sha256 cellar: :any,                 sonoma:         "077fe77362e988a54ecc7c5a254ea413ba0bf5d4f9ff7e8a9ea83d00c660c8c2"
    sha256 cellar: :any,                 ventura:        "c08e369ba170a0bde6cb81dfe622f65bc0d581843445c8a652119ac780f141d2"
    sha256 cellar: :any,                 monterey:       "9d068ee9bc10369c34766ccfa7b4156a1bc11fa99307c280d036ddbfcf2ca5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45360a667dc034d30efc3f47e39319df5261ac9305b271d96f5485608fb018e6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "botan"
  depends_on "ca-certificates"
  depends_on "gnupg"
  depends_on "libgcrypt"
  depends_on "nss"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"
  depends_on "qt"

  uses_from_macos "cyrus-sasl"

  fails_with gcc: "5"

  def install
    ENV["QC_CERTSTORE_PATH"] = Formula["ca-certificates"].pkgetc/"cert.pem"

    # FIXME: QCA_PLUGINS_INSTALL_DIR should match qt's directory "{share}/qt/plugins";
    # however, building with that directory results in segmentation faults inside
    # PluginInstance destructor at `delete _instance`.
    args = %W[
      -DBUILD_TESTS=OFF
      -DBUILD_WITH_QT6=ON
      -DQCA_PLUGINS_INSTALL_DIR=#{lib}/qt/plugins
    ]

    # Disable some plugins. qca-ossl, qca-cyrus-sasl, qca-logger,
    # qca-softstore are always built.
    %w[botan gcrypt gnupg nss pkcs11].each do |plugin|
      args << "-DWITH_#{plugin}_PLUGIN=ON"
    end

    # ensure opt_lib for framework install name and linking (can't be done via CMake configure)
    inreplace "src/CMakeLists.txt",
              /^(\s+)(INSTALL_NAME_DIR )("\$\{QCA_LIBRARY_INSTALL_DIR\}")$/,
             "\\1\\2\"#{opt_lib}\""

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"qcatool-qt6", "--noprompt", "--newpass=",
                              "key", "make", "rsa", "2048", "test.key"
  end
end