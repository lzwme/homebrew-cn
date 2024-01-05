class Atop < Formula
  desc "Advanced system and process monitor for Linux using process events"
  homepage "https:www.atoptool.nl"
  url "https:github.comAtoptoolatoparchiverefstagsv2.10.0.tar.gz"
  sha256 "29b8cf36f9dd92bb2efef19b791afa5842573fd22d7ecb14d1eeab597bcdc30c"
  license "GPL-2.0-or-later"
  head "https:github.comAtoptoolatop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1c6f352f8729ea5b0212b864586101840b399fcbb9c48fbb2515a0c651a13d48"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :linux
  depends_on "linux-headers@5.15"
  depends_on "ncurses"
  depends_on "zlib"

  def install
    if build.head?
      inreplace "version.h" do |s|
        s.sub!("$, "-#{Utils.git_short_head}\"")
      end
    end
    # As this project does not use configure, we have to configure manually:
    ENV["BINPATH"] = bin.to_s
    ENV["SBINPATH"] = bin.to_s
    ENV["MAN1PATH"] = man1.to_s
    ENV["MAN5PATH"] = man5.to_s
    ENV["MAN8PATH"] = man8.to_s
    ENV["DEFPATH"] = "prev"
    ENV["LOGPATH"] = "prev"
    # It would try to install some files suid, which is not good for users:
    inreplace "Makefile", "chmod", "true"
    # RPM and Debian packages do not use the Makefile for users, but it ensures we forget nothing:
    system "make", "-e", "genericinstall"
  end

  test do
    assert_match "Version:", shell_output("#{bin}atop -V")
    system "#{bin}atop", "1", "1"
    system "#{bin}atop", "-w", "atop.raw", "1", "1"
    system "#{bin}atop", "-r", "atop.raw", "-PCPU,DSK"
  end
end