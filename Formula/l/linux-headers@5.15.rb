class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.187.tar.gz"
  sha256 "59b69985853bce27d982f8f8f21b57d2b0627c7f1fc15c0343d5e3a12208faab"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7612007811cd29fd12a4f874378a75500d1b7412eade96a251af14e3b22033b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0abf42d3b458a9603ee1d14af0106e365e43a3aa58847976d124331d935e22e5"
  end

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end