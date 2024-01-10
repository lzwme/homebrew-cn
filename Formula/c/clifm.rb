class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https:github.comleo-archclifm"
  url "https:github.comleo-archclifmarchiverefstagsv1.16.tar.gz"
  sha256 "05980c916b987ac724deeea2cd35af99986cec205568a5f0f6e20a5b2030fb9d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "bab387e7bec0ea1c5ba4ad25108f913bfbfcc1e9044621874e2beceaf2b17990"
    sha256 arm64_ventura:  "7008f1764e42ad0100495a4d298a7c2444f6e102f0d4136be66445a0ae2bba14"
    sha256 arm64_monterey: "c3b52e78ba7310c3b53512e9d7d1e2996df4d37c1476a230baec0bb011bed5bf"
    sha256 sonoma:         "48fb33b17050e1d287dd20821a3ff4634dbd11119578f74e4317d3f5b98dad28"
    sha256 ventura:        "549bc464e59e8660cd6ca053051026b95d07e2bc566f2f53740ea3d4bb66dd79"
    sha256 monterey:       "e7defae1f1c803e390b38642ee4a53a5096a1805e5d1dfd67f754b26323d332d"
    sha256 x86_64_linux:   "ff0cf9e5dfa8682b90e28a8ff2d7ff995e520cbf8b0261ea6d14c6f063712014"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "libmagic"
  depends_on "readline"

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}clifm nonexist 2>&1", 2)
    assert_match "clifm: 'nonexist': No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}clifm --version")
  end
end