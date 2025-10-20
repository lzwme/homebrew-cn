class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.195.tar.gz"
  sha256 "123353349304e11d91dc2fa44fc4e3a1d1a0a92c04e1ba441c6247d22d983e00"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "84fd643172e4ab067bb6dc7dfeb3e3b45092be2fa3f3b7ec23cd6556e2beac73"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "49941c83ca4c3a421be0cd4ab73011a43b9e0b25ee02e7ade900fa221f1746cc"
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