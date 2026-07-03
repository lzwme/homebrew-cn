class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.07.02.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.07.02.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.07.02.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "92dd7aeff0f6d93f11aecab25670d30f974604b2d0dd71f6cdbfceecd92b31dd"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5dcf943e99b8aa608e492ae1f597eea7a588352ea351af797c24a24f20c42ba5"
    sha256 cellar: :any, arm64_sequoia: "8b5ad0ea6b4ecbae4ed4ebca30aa5c9b77d150cb22eff0c7cf04051f564ced57"
    sha256 cellar: :any, arm64_sonoma:  "7bb1d65e67f4ca5844ee5ff732ba2f0eed917a2fb37f583df73219afece6a1f2"
    sha256 cellar: :any, sonoma:        "ab2a9db6ca48cc7a1889a20a9bb93a84cddd642df474d37c18630086a073fd6f"
    sha256 cellar: :any, arm64_linux:   "49569e183bfe9c5bb3dcdd4b8af3d5b01a16aff3c89262029639a9ae327f0053"
    sha256 cellar: :any, x86_64_linux:  "53cc1d79853d9938c7094456d9b4dfc9ca1d77ea7f4d513b77c48ba9b0b93444"
  end

  depends_on "openssl@3"

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
      formula_opt_lib("openssl@3")/shared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-bigsur" : "linux"
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