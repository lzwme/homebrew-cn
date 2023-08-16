class Conman < Formula
  desc "Serial console management program supporting a large number of devices"
  homepage "https://github.com/dun/conman"
  url "https://ghproxy.com/https://github.com/dun/conman/archive/conman-0.3.1.tar.gz"
  sha256 "cd47d3d9a72579b470dd73d85cd3fec606fa5659c728ff3c1c57e970f4da72a2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "a0be94a97c0d77a9078b71d6f7be6066c5ba7f0fbb43d9c129a014804b4221f0"
    sha256 arm64_monterey: "3a7279a18eaecf1db5ce2308b7e3e534c58eb23dd8ab06767fdf003309551eac"
    sha256 arm64_big_sur:  "ba4ee04b659ea6b5663821a4a5262fe7e04cdb715fe216275f9b88c7305d80d2"
    sha256 ventura:        "694da5ae8b52314bdf7500b9c266f122ea7507c6c3f3355d329e4b13f8c9c6db"
    sha256 monterey:       "e18ed06db8ac7678344e9c55726026570a350b80f8d771b24fa14ec87547d85b"
    sha256 big_sur:        "d589fec5d6868bd0437e053d6cacbb739716033735fa6a2d5f5e4dda70a8eae5"
    sha256 x86_64_linux:   "af3f62841fa09e43d3e42e41f7a1d5eaaa57112851b87221ea46a96a0fad6d52"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "freeipmi"

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args, "--disable-silent-rules", "--sysconfdir=#{etc}"
    system "make", "install"
    inreplace pkgshare.glob("examples/*.exp"), "/usr/share/", "#{opt_share}/"
  end

  def caveats
    <<~EOS
      Before starting the conmand service, configure some consoles in #{etc}/conman.conf.
    EOS
  end

  service do
    run [opt_sbin/"conmand", "-F", "-c", etc/"conman.conf"]
    keep_alive true
  end

  test do
    assert_match "conman-#{version}", shell_output("#{bin}/conman -V 2>&1")
    assert_match "conman-#{version} FREEIPMI", shell_output("#{sbin}/conmand -V 2>&1")

    conffile = testpath/"conman.conf"
    conffile.write <<~EOS
      console name="test-sleep1" dev="/bin/sleep 30"
      console name="test-sleep2" dev="/bin/sleep 30"
    EOS

    fork { exec "#{sbin}/conmand", "-F", "-c", conffile }
    sleep 5
    assert_match(/test-sleep\d\ntest-sleep\d\n/, shell_output("#{bin}/conman -q 2>&1"))
  end
end