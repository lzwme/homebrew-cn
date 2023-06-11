class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.06.10.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.06.10.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "b57befbb9f471598a70eae66a6e8548e299b952f9c997169f51600cb28e2f8ea"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e0c2bd556b7fee58b618904c100ec63c482691603e341d368dc55b95b5731cc"
    sha256 cellar: :any,                 arm64_monterey: "e487fd4c0466d8a9356f995e6281a912e31255237c67eb367ef32495798239c4"
    sha256 cellar: :any,                 arm64_big_sur:  "5a2491684bc1327a85168c0bbb9204ce25893d68ce52338652fb9971944ae5d2"
    sha256 cellar: :any,                 ventura:        "4b6b6546b11b21ae851ee8b59abfb3b3b1f4b2f850022d296ca1a9a7401dc004"
    sha256 cellar: :any,                 monterey:       "2516408d61b3477f149552cd11e9bef22fa7f240a749042da8d205988961d602"
    sha256 cellar: :any,                 big_sur:        "f39c6d6fd0e16c2d4c1ba4240fb60aca5022af4b9469e029ca8ae784ee31d3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c686e32c723cc975400759d246a6f0da292e205d21b249cc96327494f3ea36dc"
  end

  depends_on "openssl@3"

  def install
    ENV.cxx11

    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-no-openssl" : "linux-no-openssl"
    system "./genMakefiles", os_flag
    system "make", "PREFIX=#{prefix}",
           "LIBS_FOR_CONSOLE_APPLICATION=#{libs.join(" ")}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats
    <<~EOS
      Testing executables have been placed in:
        #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end