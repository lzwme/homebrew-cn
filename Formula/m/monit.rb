class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.34.1.tar.gz"
  sha256 "ef1a05d8140bc0165ee6653b942b6ff5fa73f9aec11b02fc47c9c1cab9174152"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "60ac60dfdb8e1bcdcf9305cf6cf9be178bceb8016e24c0475232d41de70d77ca"
    sha256 cellar: :any,                 arm64_sonoma:  "90559ea6547dc4eb92f0df8d4dfa80104ea3c3478f6fe04a5f9c1bea53cc66bb"
    sha256 cellar: :any,                 arm64_ventura: "2c47080283371300d1717390c3870ec4556ecbf6673bd10970a7f4737d685ed0"
    sha256 cellar: :any,                 sonoma:        "18b34c89a6cb0f79cd642f51da090cebdd111369da14623a2ea9d6c3c65f4f1c"
    sha256 cellar: :any,                 ventura:       "f55dd26f2c2a41325e72f5462afc86e2b12a6a32681933f6efa89a3bfc1123db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b0fa9c5ce89735ddbc8a15222f038ed3a9a556a360f043409a273f43237fa7"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  service do
    run [opt_bin/"monit", "-I", "-c", etc/"monitrc"]
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end