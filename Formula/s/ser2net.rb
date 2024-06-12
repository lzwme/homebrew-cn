class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.1.tar.gz"
  sha256 "78ffee19d9b97e93ae65b5cec072da2b7b947fc484e9ccb3f535702f36f6ed19"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "be14666e8dca179c53eae12961a71c56fbc6f7f4c81c1ecd2805f547402aebe4"
    sha256 arm64_ventura:  "e2bb255e89e204d1f7bae36420fdac05a5ef3d98e0c6ea0d2c5e2c7fb79c3498"
    sha256 arm64_monterey: "5b0ea044c62f1287ce89cfb5f4da13e4a33b48df598419501b1e6850d13e2ba9"
    sha256 sonoma:         "c6b998828fda1d80e74e4ed3e728821dd26a4c6c7aa60801b31b6bac222bdbb1"
    sha256 ventura:        "c2ea63d3138e8d6f0ace1198383b6a697a6b03baf08ffde5b13e855a67bf8999"
    sha256 monterey:       "3fbb9efec50334c3fe9c6ad864aa7d2bd0cef48548f7cc30284da7493e1469af"
    sha256 x86_64_linux:   "3af87267c7d7bf92b2f7b4283651fb75fe4e01f7bdeb3d5286420cb80fe5ce2b"
  end

  depends_on "gensio"
  depends_on "libyaml"

  def install
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--datarootdir=#{HOMEBREW_PREFIX}/share",
                          "--mandir=#{man}"
    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  service do
    run [opt_sbin/"ser2net", "-n"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v", 1)
  end
end