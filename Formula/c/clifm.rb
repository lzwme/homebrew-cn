class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://ghproxy.com/https://github.com/leo-arch/clifm/archive/refs/tags/v1.15.tar.gz"
  sha256 "6248c8352f6fb77f9dc6bc0a3f84c06c881b82c08679f93ed8c32d6c208787b4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "350c6589a28e1cac903a62cabfdec54484ba79efcd27e5c8add98060f1e678a5"
    sha256 arm64_ventura:  "36721cdfa2e2310d4eda359153ec48755346c70a8f5f12c4678e094662a0cf96"
    sha256 arm64_monterey: "bec307fd1face3a1b024893459b9543932f80f92f2c3a2e053c0313b2735afc6"
    sha256 sonoma:         "f5a3f9906dafaf9144575937e973bce0f9be07e6829c48e30e0c45e7612c1b90"
    sha256 ventura:        "75c1b7c464760a8ff321e19902c6d2cdc608d29e53eecd3ea97927aa51ac12c5"
    sha256 monterey:       "749e8a1039edabd4ed43936663e2834f4a749f3ac3f50075ec195c3801d98c8a"
    sha256 x86_64_linux:   "3e203de5896f74905b4f6dd29ccd3154118a0a654ad93266092dc0e65722c242"
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

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: nonexist: No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end